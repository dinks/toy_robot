require 'spec_helper'

describe ::ToyRobot::Application do
  let(:application) { ::ToyRobot::Application.new }

  specify "instance methods" do
    should respond_to(:execute)
  end

  describe '#execute' do
    let(:response) { application.execute(instruction, arguments) }
    let(:arguments) { [] }

    subject { response }

    context 'no instruction' do
      let(:instruction) { '' }
      it { should eql(false) }
    end

    context 'invalid instruction' do
      let(:instruction) { 'invalid' }

      context 'with arguments' do
        let(:arguments) { ['one'] }
        it { should eql(false) }
      end

      context 'without arguments' do
        it { should eql(false) }
      end
    end

    context '#place' do
      let(:instruction) { 'place' }

      context 'with invalid number of arguments' do
        let(:arguments) { ['one', 'two'] }
        it { should eql(false) }
      end

      context 'with invalid arguments' do
        let(:arguments) { ['1', '1', 'invalid'] }
        it { should eql(false) }
      end

      context 'with valid arguments' do
        let(:arguments) { ['1', '1', 'south'] }
        it { should eql(true) }
      end
    end

    ['move', 'left', 'right'].each do |instruction|
      let(:instruction) { instruction }

      context 'with invalid arguments' do
        let(:arguments) { ['one'] }
        it { should eql(false) }
      end

      context 'with valid arguments' do
        context 'before #place command' do
          it { should eql(false) }
        end

        context 'after #place command' do
          before(:each) { application.execute('place', ['2', '2', 'south']) }

          it { should eql(true) }
        end
      end

      context '#report' do
        let(:instruction) { 'report' }

        context 'with invalid arguments' do
          let(:arguments) { ['one'] }
          it { should eql(false) }
        end

        context 'with valid arguments' do
          context 'before #place command' do
            it { should match /The Robot not placed yet !!!!!/ }
          end

          context 'after #place command' do
            before(:each) { application.execute('place', ['2', '2', 'south']) }

            it { should match /is placed at \[ 2, 2 \] facing SOUTH/ }
          end
        end
      end
    end
  end
end
