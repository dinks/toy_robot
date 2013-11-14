# Load the lib to the path
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'bundler/setup'
require 'toy_robot'

# Add the support files
Dir[File.join(File.dirname(__FILE__),'support', '**', '*.rb')].each { |file|
  require file
}

RSpec.configure do |config|
  config.order = 'rand'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
