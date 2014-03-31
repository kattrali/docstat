lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |gem|
  gem.authors       = ["Delisa Mason"]
  gem.email         = ["iskanamagus@gmail.com"]
  gem.description   = %q{Coverage statistics for Cocoa documentation sets}
  gem.summary       = %q{A command-line utility for checking the documentation coverage of a Cocoa library}
  gem.homepage      = "https://github.com/kattrali/docstat"

  gem.name          = "docstat"
  gem.require_paths = ["lib"]
  gem.extra_rdoc_files = ['README.md','CHANGELOG.md','LICENSE']
  gem.version       = DocStat::VERSION
  gem.add_development_dependency('bacon')
  gem.add_development_dependency('prettybacon')
  gem.add_development_dependency('rake')
  gem.add_dependency('sqlite3')
  gem.files = %W{
    Gemfile
    LICENSE
    CHANGELOG.md
    README.md
    bin/docstat
    bin/docstat-test
    lib/docstat.rb
    lib/version.rb
    lib/docstat/container.rb
    lib/docstat/token.rb
  }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
end
