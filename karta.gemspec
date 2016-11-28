# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'karta/version'

Gem::Specification.new do |spec|
  spec.name          = "karta"
  spec.version       = Karta::VERSION
  spec.authors       = ["Samuel Nilsson"]
  spec.email         = ["mail@samuelnilsson.me"]
  spec.summary       = %q{A simple Ruby gem for creating mappers which map one object to another.}
  spec.description   = %q{Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("activesupport", ">= 4.0.0")

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5.0"
  spec.add_development_dependency "byebug", "~> 9.0.6"
end
