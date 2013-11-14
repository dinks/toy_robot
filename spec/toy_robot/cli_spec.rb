require 'spec_helper'
require 'toy_robot/shared_examples'

describe ::ToyRobot::CLI do

  let(:cli) { ::ToyRobot::CLI.new }

  subject { cli }

  describe "executing instructions from a file" do
    let(:default_file) { "instructions.txt" }
    let(:output) { capture(:stdout) { cli.start } }

    context "with valid commands" do
      valid_test_data.each do |data|
        it_should_behave_like 'executing commands from a file', data
      end
    end

    context "with invalid commands" do
      invalid_test_data.each do |data|
        it_should_behave_like 'executing commands from a file', data
      end
    end
  end

  describe 'executing instructions from the command line' do
    let(:output) { capture(:stdout) { cli.start } }

    context "with valid commands" do
      valid_test_data.each do |data|
        it_should_behave_like 'executing from the command line', data
      end
    end

    context "with invalid commands" do
      invalid_test_data.each do |data|
        it_should_behave_like 'executing from the command line', data
      end
    end
  end

end
