require 'toy_robot/board'
require 'toy_robot/robot'

module ToyRobot
  # Application which is incharge of executing instructions
  class Application

    VALID_INSTRUCTIONS = ::ToyRobot::Robot::VALID_INSTRUCTIONS

    # Initialize the Application
    #
    def initialize
      @board = Board.new
      @robot = Robot.new(@board)
    end

    # Execute Commands
    #
    # @params [String] instruction Instruction to be executed
    # @params [Array<String>] args Arguements of the Instruction
    #
    def execute(instruction, args)
      @robot.instruct(instruction, args)
    end

  end
end
