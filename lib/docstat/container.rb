
module DocStat
  class Container
    attr_reader :name, :tokens

    QUERY = "select ZCONTAINERNAME,ZTOKENNAME,ZTYPENAME,ZTOKENMETAINFORMATION.ZABSTRACT,ZDECLARATION,ZRETURNVALUE.ZABSTRACT from ZTOKEN \
      inner join ZCONTAINER on ZTOKEN.ZCONTAINER = ZCONTAINER.Z_PK \
      inner join ZTOKENTYPE on ZTOKEN.ZTOKENTYPE = ZTOKENTYPE.Z_PK \
      inner join ZTOKENMETAINFORMATION on ZTOKEN.Z_PK = ZTOKENMETAINFORMATION.ZTOKEN \
      left join ZRETURNVALUE on (ZTOKENMETAINFORMATION.ZRETURNVALUE = ZRETURNVALUE.Z_PK) \
      order by ZCONTAINERNAME"

    def self.from_sqlite path
      db = SQLite3::Database.new(path)
      rows = db.execute(QUERY).to_a
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
