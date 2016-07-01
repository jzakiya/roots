# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roots/version'

Gem::Specification.new do |gem|
  gem.name          = "roots"
  gem.version       = Roots::VERSION
  gem.authors       = ["Jabari Zakiya"]
  gem.email         = ["jzakiya@gmail.com"]

  gem.summary       = %q{two methods 'root' and 'roots' to compute all n roots of real/complex numbers}
  gem.description   = %q{For val (real/complex) and root n: val.root(n,[1-n]) and val.roots(n, [opt]); Roots.digits_to_show to see/change number of digts to show}
  gem.homepage      = "https://github.com/jzakiya/roots"

  gem.files         = ["lib/roots.rb"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.license       = "GPLv2+"
  gem.required_ruby_version = ">= 1.9"
  
  gem.add_development_dependency "bundler", "~> 1.9"
  gem.add_development_dependency "rake", "~> 10.0"
end