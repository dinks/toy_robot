# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'toy_robot/version'

Gem::Specification.new do |spec|
  spec.name          = "toy_robot"
  spec.version       = ToyRobot::VERSION
  spec.authors       = ["Dinesh Vasudevan"]
  spec.email         = ["dinesh.vasudevan@gmail.com"]
  spec.description   = %q{ Gem version for the Toy Robot }
  spec.summary       = %q{ The Toy Robot does some cool stuff }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  # CLI
  spec.add_development_dependency 'thor'

  # State Machine for the Robot
  spec.add_development_dependency 'state_machine'

  # Tests
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "flog"
  spec.add_development_dependency "flay"
  spec.add_development_dependency "roodi"
  spec.add_development_dependency "metric_fu"
end
