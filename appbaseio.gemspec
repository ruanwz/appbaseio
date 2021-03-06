# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'appbaseio/version'

Gem::Specification.new do |spec|
  spec.name          = "appbaseio"
  spec.version       = Appbaseio::VERSION
  spec.authors       = ["David Ruan"]
  spec.email         = ["ruanwz@gmail.com"]
  spec.summary       = %q{appbaseio ruby rest client}
  spec.description   = %q{appbaseio ruby rest client}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "virtus", ">= 1.0"
  spec.add_dependency "faraday", ">= 0.9"
  spec.add_dependency "faraday_middleware", ">= 0.9.1"
  spec.add_dependency "hashie", ">= 3.3.1"

  spec.add_development_dependency "bundler", ">= 1.7"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", ">= 3.0"
  spec.add_development_dependency "pry", ">= 0.10"
  spec.add_development_dependency "vcr", ">= 2.9"
  spec.add_development_dependency "webmock", ">= 1.20"
  spec.add_development_dependency "timecop", ">= 0.7"
end
