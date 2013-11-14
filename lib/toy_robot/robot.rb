require 'state_machine'

module ToyRobot
  # The Robot State Machine
  class Robot
    # List of Valid Orientation
    VALID_ORIENTATIONS = %w( NORTH EAST SOUTH WEST ).freeze

    # Valid Instructions and the arguments allowed
    VALID_INSTRUCTIONS = {
      PLACE: {
        args_size: 3
      },
      MOVE: {
        args_size: 0
      },
      LEFT: {
        args_size: 0
      },
      RIGHT: {
        args_size: 0
      },
      REPORT: {
        args_size: 0
      }
    }.freeze

    # Progress Vectors with respect to Orientation
    PROGRESS_VECTORS = {
      NORTH:  { x: 0, y: 1 },
      EAST:   { x: 1, y: 0 },
      SOUTH:  { x: 0, y: -1 },
      WEST:   { x: -1, y: 0 }
    }.freeze

    # Check if the Instruction is Valid
    #
    # @params [String] instruction Instruction to be checked
    # @params [Array<String>] args Arguements of the Instruction
    #
    def self.is_valid_instruction?(instruction, args)
      valid_instruction = Robot::VALID_INSTRUCTIONS[instruction.to_sym] || false
      valid_instruction && valid_instruction[:args_size] == args.length
    end

    attr_accessor :orientation
    attr_reader   :board

    # State Machine for the Robot
    state_machine :state, initial: :unset do
      # Change Orientation on the Left and Right Instruction
      before_transition on: [ :left, :right] do |robot, transition|
        if robot.orientation
          index = Robot::VALID_ORIENTATIONS.index(robot.orientation)
          robot.orientation =   case transition.event
                                when :left
                                  Robot::VALID_ORIENTATIONS.rotate(-1)[index]
                                when :right
                                  Robot::VALID_ORIENTATIONS.rotate(1)[index]
                                else
                                  robot.orientation
                                end
        else
          throw :halt
        end
      end

      # Place the Robot on the Board on the Place Instruction
      before_transition on: :place do |robot, transition|
        co_x, co_y, orient = transition.args.flatten
        co_x, co_y = co_x.to_i, co_y.to_i
        index = Robot::VALID_ORIENTATIONS.index(orient.upcase)

        if index && robot.board.contains_coordinates?(co_x, co_y)
          robot.orientation = Robot::VALID_ORIENTATIONS[index]
          throw :halt unless robot.board.move_to(co_x, co_y)
        else
          throw :halt
        end
      end

      # Move the Robot on the Move Instruction
      before_transition on: :move do |robot, transition|
        if robot.orientation
          vector = Robot::PROGRESS_VECTORS[robot.orientation.to_sym]
          throw :halt unless robot.board.translate_to(vector[:x], vector[:y])
        else
          throw :halt
        end
      end

      # Place is always valid
      event :place do
        transition :unset => :placed, :placed => same
      end

      # Left, Right, Move is valid iff the Robot has been placed
      [:left, :right, :move].each do |after_place_event|
        event after_place_event do
          transition all - [:unset] => :placed, if: ->(robot){ robot.placed? }
        end
      end

      # The States are :unset and :placed
      state :unset
      state :placed
    end

    # Initialization of the Robot
    #
    # @params [Board] board Board where the Robot should be placed
    #
    def initialize(board)
      @board = board

      # Without this super call, the State Machine ceases to work !
      super()
    end

    # Instruct the Robot
    #
    # @params [String] instruction Instruction
    # @params [Array<Sring>] args Arguements of the Instruction
    #
    def instruct(instruction, *args)
      if  instruction &&
          ::ToyRobot::Robot.is_valid_instruction?(instruction.upcase, *args)

        converted_instruction = instruction.to_s.downcase
        if args.flatten.empty?
          self.send(converted_instruction)
        else
          self.send(converted_instruction, *args)
        end
      else
        false
      end
    end

    # Report the Status of the Robot
    #
    def report
      if self.placed?
        "The Robot is placed at [ #{@board.report} ] facing #{@orientation}"
      else
        "The Robot not placed yet !!!!!"
      end
    end

  end
end
