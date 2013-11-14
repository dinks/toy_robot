require 'spec_helper'

all_orientations = ::ToyRobot::Robot::VALID_ORIENTATIONS
all_instructions = ::ToyRobot::Robot::VALID_INSTRUCTIONS

describe ::ToyRobot::Robot do
  let(:board) { ::ToyRobot::Board.new }
  let(:robot_class) { ::ToyRobot::Robot }
  let(:robot) { robot_class.new(board) }

  subject { robot }

  specify "instance methods" do
    should respond_to(:instruct)
    should respond_to(:report)
    should respond_to(:place)
    should respond_to(:move)
    should respond_to(:left)
    should respond_to(:right)
  end

  context '#instruct' do
    let(:response) { robot.instruct(instruction, args) }

    subject { response }

    context "for valid PLACE" do
      let(:instruction) { 'PLACE' }
      let(:args) { ['1', '1', 'east'] }

      it { should eql(true) }

      context 'after positioning' do
        before(:each) { robot.instruct('place', ['4', '1', 'east']) }

        it { should eql(true) }
      end

      context 'with invalid arguments' do
        let(:args) { ['1', '1', 'invalid'] }

        it { should eql(false) }
      end
    end

    context "for valid REPORT" do
      let(:instruction) { 'REPORT' }
      let(:args) { [] }

      context 'before positioning' do
        it { should match /The Robot not placed yet !!!!!/ }

        context 'with invalid arguments' do
          let(:args) { ['1', '1', 'invalid'] }

          it { should eql(false) }
        end
      end

      context 'after positioning' do
        before(:each) { robot.instruct('place', ['1', '1', 'east']) }

        it { should match /is placed at \[ 1, 1 \] facing EAST/ }

        context 'with invalid arguments' do
          let(:args) { ['1', '1', 'invalid'] }

          it { should eql(false) }
        end
      end
    end

    context 'for valid MOVE' do
      let(:instruction) { 'MOVE' }
      let(:args) { [] }

      context 'after positioning' do
        before(:each) { robot.instruct('place', [co_x, co_y, orientation]) }

        context 'with EAST orientation' do
          let(:orientation) { 'EAST' }

          context 'at the edge' do
            let(:co_x) { 4 }
            let(:co_y) { 0 }

            it { should eql(false) }
          end
        end
      end
    end

    ['MOVE', 'LEFT', 'RIGHT'].each do |valid_instruction|
      context "for valid #{valid_instruction}" do
        let(:instruction) { valid_instruction }
        let(:args) { [] }

        context 'before positioning' do
          it { should eql(false) }

          context 'with invalid arguments' do
            let(:args) { ['1', '1', 'invalid'] }

            it { should eql(false) }
          end
        end

        context 'after positioning' do
          before(:each) { robot.instruct('place', ['1', '1', orientation]) }

          all_orientations.each do |valid_orientation|
            let(:orientation) { valid_orientation }

            it { should eql(true) }

            context 'check orientation' do
              before(:each) { robot.instruct(instruction, args) }

              subject { robot.orientation }

              it 'should have correct orientation' do
                idx =  all_orientations.index(orientation)
                orient =  case valid_instruction
                          when 'MOVE'
                            orientation
                          when 'LEFT'
                            all_orientations.rotate(-1)[idx]
                          when 'RIGHT'
                            all_orientations.rotate(1)[idx]
                          end
                should eql(orient)
              end
            end
          end

          context 'with invalid arguments' do
            let(:args) { ['1', '1', 'invalid'] }

            it { should eql(false) }
          end
        end
      end
    end
  end

  context '#is_valid_instruction' do
    let(:response) { robot_class.is_valid_instruction?(instruction, args) }

    subject { response }

    all_instructions.each do |valid_instruction|
      context "for valid #{valid_instruction[0]}" do
        let(:instruction) { valid_instruction[0] }
        let(:args) { Array.new(valid_instruction[1][:args_size], 'valid') }

        it { should eql(true) }

        context 'with invalid arguments' do
          let(:args) { Array.new(10, 'invalid') }

          it { should eql(false) }
        end
      end
    end

    context 'for invalid instructions' do
      let(:instruction) { 'invalid' }
      let(:args) { [] }

      it { should eql(false) }
    end
  end
end
