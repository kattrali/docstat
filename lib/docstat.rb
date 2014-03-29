$:.unshift File.expand_path('../../lib', __FILE__)

require 'sqlite3'
require 'docstat/container'
require 'docstat/token'

module DocStat

  def self.process docset_path
    db_path    = File.join(docset_path, 'Contents/Resources/docSet.dsidx')
    containers = Container.from_sqlite(db_path)
    tokens     = containers.map(&:tokens).flatten
    if tokens.size > 0
      overall_ratio = tokens.select(&:documented?).size.to_f/tokens.size
    else
      overall_ratio = 1
    end
    print "#{tokens.size} tokens, #{((overall_ratio*1000).to_i/1000.0) * 100}% documented"
    { "containers" => containers.map(&:to_hash) , "ratio" => overall_ratio }
  end

  def self.test_ratio docset_path, passing_ratio
    false
  end
end
