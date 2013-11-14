require 'spec_helper'

shared_examples_for 'executing commands from a file' do |data|
  it 'should process the commands' do
    cli.stub(:options) { { file: default_file } }
    expected_outputs = data[:output]
    commands = StringIO.new(data[:input]).map { |a| a.strip }
    File.stub(:readlines).with(default_file) do
      StringIO.new(data[:input]).map { |a| a.strip.chomp }
    end
    expected_outputs.each do |expected_output|
      expect(output).to include(expected_output)
    end
  end
end

shared_examples_for 'executing from the command line' do |data|
  it "should process the commands and output the results" do
    expected_outputs = data[:output]
    commands = StringIO.new(data[:input]).map { |a| a.strip }
    cli.stub(:gets).and_return(*commands, "EXIT")
    expected_outputs.each do |expected_output|
      expect(output).to include(expected_output)
    end
  end
end
