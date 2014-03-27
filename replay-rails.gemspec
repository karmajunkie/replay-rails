# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'replay/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "replay-rails"
  spec.version       = Replay::Rails::VERSION
  spec.authors       = ["karmajunkie"]
  spec.email         = ["keith.gaddis@gmail.com"]
  spec.description   = %q{Includes some Rails-support code for Replay}
  spec.summary       = %q{replay-rails provides some glue and support code for using Replay with Rails}
  #spec.homepage      = "http://"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "replay", "~>0.1.0"
  spec.add_runtime_dependency "rails", ">3.2.0"
end
