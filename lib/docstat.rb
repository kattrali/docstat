$:.unshift File.expand_path('../../lib', __FILE__)

require 'sqlite3'
require 'docstat/container'

module DocStat

  # Parses a docset and returns a representation of the
  # documented tokens within the library.
  # The general structure is as follows:
  #
  # {
  #   'ratio': decimal
  #   'containers': [
  #     {
  #       'name': 'class name',
  #       'ratio': decimal
  #       'tokens': [
  #         {
  #           'name': 'name of token',
  #           'type': 'property or message type',
  #           'abstract': 'description of token',
  #           'declaration': 'formal declaration',
  #           'returns': 'description of return value',
  #           'documented': boolean
  #         }, ...
  #       ]
  #     }, ...
  #   ]
  # }
  def self.process docset_path
    containers = containers_from_docset(docset_path)
    { "containers" => containers.map(&:to_hash) , "ratio" => overall_ratio(containers) }
  end

  def self.test_ratio docset_path, passing_ratio
    containers = containers_from_docset(docset_path)
    overall_ratio(containers) >= passing_ratio
  end

  private

  def self.containers_from_docset docset_path
    db_path = File.join(docset_path, 'Contents/Resources/docSet.dsidx')
    Container.from_sqlite(db_path)
  end

  def self.overall_ratio containers
    tokens = containers.map(&:tokens).flatten
    if tokens.size > 0
      overall_ratio = tokens.select(&:documented?).size.to_f/tokens.size
    else
      overall_ratio = 1
    end
    overall_ratio
  end
end
