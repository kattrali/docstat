$:.unshift File.expand_path('..', __FILE__)

require 'token'

module DocStat
  class Container
    attr_reader :name, :tokens

    QUERY = "select ZCONTAINERNAME,ZTOKENNAME,ZTYPENAME,ZTOKENMETAINFORMATION.ZABSTRACT,ZDECLARATION from ZTOKEN \
      left join ZCONTAINER on ZTOKEN.ZCONTAINER = ZCONTAINER.Z_PK \
      left join ZTOKENTYPE on ZTOKEN.ZTOKENTYPE = ZTOKENTYPE.Z_PK \
      left join ZTOKENMETAINFORMATION on ZTOKEN.Z_PK = ZTOKENMETAINFORMATION.ZTOKEN \
      order by ZCONTAINERNAME"

    QUERY_WITH_RETURN_VALUES = "select ZCONTAINERNAME,ZTOKENNAME,ZTYPENAME,ZTOKENMETAINFORMATION.ZABSTRACT,ZDECLARATION,ZRETURNVALUE.ZABSTRACT from ZTOKEN \
      left join ZCONTAINER on ZTOKEN.ZCONTAINER = ZCONTAINER.Z_PK \
      left join ZTOKENTYPE on ZTOKEN.ZTOKENTYPE = ZTOKENTYPE.Z_PK \
      left join ZTOKENMETAINFORMATION on ZTOKEN.Z_PK = ZTOKENMETAINFORMATION.ZTOKEN \
      left join ZRETURNVALUE on ZTOKENMETAINFORMATION.ZRETURNVALUE = ZRETURNVALUE.Z_PK \
      order by ZCONTAINERNAME"

    RETURNVALUES_QUERY = "SELECT * FROM sqlite_master WHERE type='table'"

    def self.from_sqlite path
      db = SQLite3::Database.new(path)
      rows = has_return_values?(db) ? db.execute(QUERY_WITH_RETURN_VALUES) : db.execute(QUERY)
      container_groups = rows.group_by {|r| r.first }
      groups = container_groups.map do |name, tokens|
        self.new(name, tokens)
      end
      db.close
      groups
    end

    def initialize name, tokens
      @name, @tokens = name, tokens.map {|t| Token.new(t)}
    end

    def self.has_return_values? database
      database.execute(RETURNVALUES_QUERY).detect {|r| r[1] == 'ZRETURNVALUE'} != nil
    end

    def to_hash
      {
        "name"   => name,
        "tokens" => tokens.map(&:to_hash),
        "ratio"  => ratio
      }
    end

    def ratio
      documentation_ratio(tokens)
    end

    def method_documentation_ratio
      documentation_ratio(tokens.select(:method?))
    end

    def property_documentation_ratio
      documentation_ratio(tokens.select(:property?))
    end

    def description
      token_description = tokens.map {|t| t.description}.join("\n")
      "#{name}:\n#{token_description}"
    end

    private

    def documentation_ratio token_set
      if token_set.size > 0
        documented = token_set.select(&:documented?)
        documented.size.to_f / token_set.size
      else
        1
      end
    end
  end
end
