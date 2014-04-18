# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exec-simple'

Gem::Specification.new do |spec|
  spec.name          = "exec-simple"
  spec.version       = ExecSimple::VERSION
  spec.authors       = ["Dominik Richter"]
  spec.email         = ["dominik.richter@gmail.com"]
  spec.summary       = %q{Simply run commands.}
  spec.description   = %q{A simple command runner interface.}
  spec.homepage      = "http://github.com/arlimus/exec-simple"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_dependency "concurrent-ruby", "~> 0.5"
end
