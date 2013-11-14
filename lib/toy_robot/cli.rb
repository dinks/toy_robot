# Similar to Guard
require 'thor'

require 'toy_robot/version'
require 'toy_robot/application'

module ToyRobot

  # CLI for the Toy Robot
  class CLI < Thor
    default_task :start

    method_option :file,
                  type:    :string,
                  default: false,
                  aliases: '-f',
                  banner:  'File which has all the commands to execute'

    method_option :output,
                  type:    :string,
                  default: false,
                  aliases: '-o',
                  banner:  'Output to File'

    method_option :debug,
                  type:    :boolean,
                  default: false,
                  aliases: '-d',
                  banner:  'Show debug information'

    desc 'start', 'Starts the Application'

    # Starts the Application - Default
    #
    def start
      application = Application.new

      get_instructions do |instruction, args|
        write_output(instruction, application.execute(instruction, args))
      end
    end

    desc 'version', 'Show the Guard version'
    map %w(-v --version) => :version

    # Shows the current version of ToyRobot.
    #
    def version
      puts "ToyRobot version #{ ::ToyRobot::VERSION }"
    end

    # Sanitize the Instruction
    #
    # @params [String] instruction Instruction
    #
    def self.santize_instruction(instruction)
      args = instruction.scan(/-?\w+/)
      command = args.shift
      [ command, args ]
    end

    # Describes all the processing methods
    no_tasks do

      # Get Instruction for Processing
      #
      # @params [Block] block Block to process the commands
      #
      def get_instructions(&block)
        if filename = options[:file]
          read_from_file(filename, &block)
        else
          read_from_command_line(&block)
        end
      end

      # Read Contents from the File
      #
      # @params [String] filename Filename to read from
      # @params [Block] block Block to process the commands
      #
      def read_from_file(filename, &block)
        begin
          File.readlines(filename).map do |line|
            yield ::ToyRobot::CLI.santize_instruction(line.strip.chomp)
          end
        rescue
          puts "Filename not specified or does not exist"
        end
      end

      # Read Contents from the Command Line
      #
      # @params [Block] block Block to process the commands
      #
      def read_from_command_line(&block)
        line = true
        while line
          print "ToyRobot > "
          line = gets.chomp
          case line
          when /EXIT/i
            break
          else
            yield ::ToyRobot::CLI.santize_instruction(line)
          end
        end
      end

      # Write the output of the instruction
      #
      # @params [String] instruction Filename to read from
      # @params [id] output Output of the executed command
      #
      def write_output(instruction, output)
        is_debug = options[:debug]
        format = "#{ is_debug ? "#{instruction} --> " : "" }#{output}"
        if output.instance_of?(String) || is_debug
          if filename = options[:output]
            File.open(filename, 'a') do |output_file|
              output_file.puts format
            end
          else
            puts format
          end
        end
      end

    end

  end

end
