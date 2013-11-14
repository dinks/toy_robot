
module ToyRobot
  # Board for the Robot
  class Board

    attr_reader :placed_coordinate_x, :placed_coordinate_y

    # Initializes the Board
    #
    # @params [Integer] units_available Units on the board (by default 5)
    #
    def initialize(units_available=5)
      @placed_coordinate_x, @placed_coordinate_y = nil, nil
      last_cell = units_available-1
      @left_boundary, @bottom_boundary = 0, 0
      @right_boundary, @top_boundary = last_cell, last_cell
    end

    # Position to move the Robot
    #
    # @params [Integer] place_x X Coordinate of the Movement
    # @params [Integer] place_y Y Coordinate of the Movement
    #
    def move_to(place_x, place_y)
      if contains_coordinates?(place_x, place_y)
        @placed_coordinate_x, @placed_coordinate_y = place_x, place_y
        true
      else
        false
      end
    end

    # Translate the Robot Movement
    #
    # @params [Integer] translate_x X Coordinate of the Translation
    # @params [Integer] translate_y Y Coordinate of the Translation
    #
    def translate_to(translate_x, translate_y)
      return false unless is_positioned?
      changed_x = @placed_coordinate_x + translate_x
      changed_y = @placed_coordinate_y + translate_y
      if contains_coordinates?(changed_x, changed_y)
        @placed_coordinate_x, @placed_coordinate_y = changed_x, changed_y
        true
      else
        false
      end
    end

    # Check if the Coordinates are within bounds
    #
    # @params [Integer] coordinate_x X Coordinate to check
    # @params [Integer] coordinate_y Y Coordinate to check
    #
    def contains_coordinates?(coordinate_x, coordinate_y)
      coordinate_x.between?(@left_boundary, @right_boundary) &&
      coordinate_y.between?(@bottom_boundary, @top_boundary)
    end

    # Report the Status of the Robot on this Board
    #
    def report
      "#{@placed_coordinate_x}, #{@placed_coordinate_y}" if is_positioned?
    end

    private
      def is_positioned?
        @placed_coordinate_x != nil && @placed_coordinate_y != nil
      end
  end
end
