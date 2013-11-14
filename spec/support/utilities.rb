# Utilities

def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
end

def valid_test_data
  [
    { # Provided example 1
      input: "PLACE 0,0,NORTH\r
              MOVE\r
              REPORT",
      output: ["The Robot is placed at [ 0, 1 ] facing NORTH"]
    },

    { # Provided example 2
      input: "PLACE 0,0,NORTH\r
              LEFT\r
              REPORT",
      output: ["The Robot is placed at [ 0, 0 ] facing WEST"]
    },

    { # Provided example 3
      input: "PLACE 1,2,EAST\r
              MOVE\r
              MOVE\r
              LEFT\r
              MOVE\r
              REPORT",
      output: ["The Robot is placed at [ 3, 3 ] facing NORTH"]
    },

    { # Commands before placing
      input: "MOVE\r
              MOVE\r
              LEFT\r
              RIGHT\r
              MOVE\r
              PLACE 1,2,EAST\r
              MOVE\r
              REPORT",
      output: ["The Robot is placed at [ 2, 2 ] facing EAST"]
    },

    { # Multiple placings
      input: "PLACE 1,2,EAST\r
              PLACE 0,0,NORTH\r
              PLACE 4,4,WEST\r
              REPORT",
      output: ["The Robot is placed at [ 4, 4 ] facing WEST"]
    },

    { # Attempting to go out of bounds
      input: "PLACE 0,0,WEST\r
              MOVE\r
              LEFT\r
              MOVE\r
              PLACE 4,4,NORTH\r
              MOVE\r
              RIGHT\r
              MOVE\r
              REPORT",
      output: ["The Robot is placed at [ 4, 4 ] facing EAST"]
    },

    { # Multiple calls to report
      input: "PLACE 0,0,WEST\r
              REPORT\r
              PLACE 4,4,NORTH\r
              REPORT",
      output: [
              "The Robot is placed at [ 0, 0 ] facing WEST",
              "The Robot is placed at [ 4, 4 ] facing NORTH"
            ]
    },

    { # Extended commands are ignored;
      input: "PLACE 0,0,NORTH\r
              MOVE\r
              BLOCK\r
              MOVE\r
              LOLO\r
              REPORT",
      output: ["The Robot is placed at [ 0, 2 ] facing NORTH"]
    }
  ]
end

def invalid_test_data
  [
    { # Invalid commands, bad placing arguments, placing off board
      input: "INVALID\r
              FRAGGLE\r
              PLACE A,0,NORTH\r
              PLACE 0,B,NORTH\r
              PLACE 0,0,SPACE\r
              PLACE 5,5,SOUTH\r
              PLACE -2,-2,WEST\r
              REPORT",
      output: [""]
    },

    { # No commands, just a return carriage
      input: "\r",
      output: [""]
    }
  ]
end

