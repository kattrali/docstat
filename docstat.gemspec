Gem::Specification.new do |gem|
  gem.authors       = ["Delisa Mason"]
  gem.email         = ["iskanamagus@gmail.com"]
  gem.description   = %q{Coverage statistics for Cocoa documentation sets}
  gem.summary       = %q{A command-line utility for checking the documentation coverage of a Cocoa library}
  gem.homepage      = "https://github.com/docstat"

  gem.name          = "docstat"
  gem.require_paths = ["lib"]
  gem.extra_rdoc_files = ['README.md','CHANGELOG.md']
  gem.version       = '1.0.0'
  gem.add_development_dependency('bacon')
  gem.add_dependency('sqlite3')
  gem.files = %W{
    Gemfile
    LICENSE
    LICENSE.txt
    CHANGELOG.md
    README.md
    bin/docstat
    lib/docstat.rb
  }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec|features)/})
end