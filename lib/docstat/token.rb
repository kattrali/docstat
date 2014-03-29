
class Token
  attr_reader :name, :type, :abstract, :declaration, :return_value

  METHOD_TYPES   = ['clm','clfm','instm','intfm']
  PROPERTY_TYPES = ['instp','intfp']
  TYPE_MAPPING = {
    'clm' => 'class method',
    'clfm' => 'class category method',
    'instm' => 'instance method',
    'intfm' => 'instance method',
    'instp' => 'instance property',
    'intfp' => 'instance property'
  }

  def initialize property_ary
    _, @name, @type, @abstract, @declaration, @return_value = *property_ary
  end

  def to_hash
    {
      "name" => name,
      "type" => pretty_type,
      "abstract" => abstract,
      "declaration" => declaration,
      "returns" => return_value,
      "documented" => documented?
    }
  end

  def documented?
    # TODO: check parameter docs as well?
    !((abstract.nil? || abstract.empty?) && (return_value.nil? || return_value.empty?))
  end

  def method?
    METHOD_TYPES.include?(type)
  end

  def property?
    PROPERTY_TYPES.include?(type)
  end

  def pretty_type
    TYPE_MAPPING[type]
  end

  def description
    "#{name} (#{type}) - #{abstract}"
  end
end