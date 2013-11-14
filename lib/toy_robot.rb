require 'toy_robot/version'

require 'toy_robot/cli'

# ToyRobot Module
module ToyRobot

  class << self

    def instance
      @app ||= Application.new
    end

    def self.method_missing(method_sym, *arguments, &block)
      if ::ToyRobot::Application::VALID_INSTRUCTIONS.include? method_sym
        @app.instruct(method_sym.to_s.upcase, *arguments)
      else
        super
      end
    end

    def self.respond_to?(method_sym, include_private = false)
      if ::ToyRobot::Application::VALID_INSTRUCTIONS.include? method_sym
        true
      else
        super
      end
    end
  end

end
