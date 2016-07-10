# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deptree/version'

Gem::Specification.new do |spec|
  spec.name          = "deptree"
  spec.version       = Deptree::VERSION
  spec.authors       = ["Andrzej Kajetanowicz"]
  spec.email         = ["Andrzej.Kajetanowicz@gmail.com"]
  spec.summary       = %q{Easly manage initialization steps in your Ruby application.}
  spec.description   = %q{Easly manage initialization steps in your Ruby application.}
  spec.homepage      = "https://github.com/kajetanowicz/deptree"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
end
