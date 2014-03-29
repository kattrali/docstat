
class Token
  attr_reader :name, :type, :abstract, :declaration

  METHOD_TYPES   = ['clm','clfm','instm','instfm']
  PROPERTY_TYPES = ['instp','instfp']

  def initialize property_ary
    container_name, @name, @type, @abstract, @declaration = *property_ary
  end

  def to_hash
    {
      "name" => name,
      "type" => type,
      "abstract" => abstract,
      "declaration" => declaration,
      "documented" => documented?
    }
  end

  def documented?
    # TODO: check return type documentation and parameter docs as well?
    !(abstract.nil? || abstract.empty?)
  end

  def method?
    METHOD_TYPES.include?(type)
  end

  def property?
    PROPERTY_TYPES.include?(type)
  end

  def description
    "#{name} (#{type}) - #{abstract}"
  end
end