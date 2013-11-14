require 'spec_helper'

describe ::ToyRobot::Board do
  let(:board) { ::ToyRobot::Board.new }

  specify "instance methods" do
    should respond_to(:move_to)
    should respond_to(:translate_to)
    should respond_to(:contains_coordinates?)
    should respond_to(:report)
  end

  describe '#contains_coordinates?' do
    let(:result) { board.contains_coordinates?(coordinate_x, coordinate_y) }
    let(:coordinate_x) { 0 }
    let(:coordinate_y) { 0 }

    subject { result }

    it { should eql(true) }

    context 'with invalid x coordinate' do
      let(:coordinate_x) { 5 }

      it { should eql(false) }
    end

    context 'with invalid y coordinate' do
      let(:coordinate_y) { 5 }

      it { should eql(false) }
    end
  end

  describe '#translate_to' do
    let(:result) { board.translate_to(coordinate_x, coordinate_y) }
    let(:coordinate_x) { 0 }
    let(:coordinate_y) { 0 }

    subject { result }

    it { should eql(false) }

    context 'after positioned' do
      before(:each) { board.move_to(initial_x, initial_y) }

      let(:initial_x) { 0 }
      let(:initial_y) { 0 }

      it { should eql(true) }

      context 'with valid coordinates' do
        before(:each) { result }

        context 'sets placed_coordinate_x' do
          let(:coordinate_x) { 2 }

          subject { board.placed_coordinate_x }

          it { should eql(initial_x + coordinate_x) }
        end

        context 'sets placed_coordinate_x' do
          let(:coordinate_y) { 2 }

          subject { board.placed_coordinate_y }

          it { should eql(initial_y + coordinate_y) }
        end
      end

      context 'with invalid x coordinate' do
        context 'large' do
          let(:coordinate_x) { 5 }

          it { should eql(false) }
        end

        context 'out of bounds' do
          let(:initial_x) { 2 }
          let(:coordinate_x) { 3 }

          it { should eql(false) }
        end
      end

      context 'with invalid y coordinate' do
        context 'large' do
          let(:coordinate_y) { 5 }

          it { should eql(false) }
        end

        context 'out of bounds' do
          let(:initial_y) { 2 }
          let(:coordinate_y) { 3 }

          it { should eql(false) }
        end
      end
    end
  end

  describe '#report' do
    let(:result) { board.report }

    subject { result }

    it { should eql(nil) }

    context 'after positioned' do
      before(:each) { board.move_to(coordinate_x, coordinate_y) }
      let(:coordinate_x) { 1 }
      let(:coordinate_y) { 2 }

      it { should match /1, 2/  }
    end
  end

  describe '#move_to' do
    let(:result) { board.move_to(coordinate_x, coordinate_y) }
    let(:coordinate_x) { 0 }
    let(:coordinate_y) { 0 }

    subject { result }

    it { should eql(true) }

    context 'with valid coordinates' do
      before(:each) { result }

      context 'sets placed_coordinate_x' do
        let(:coordinate_x) { 2 }

        subject { board.placed_coordinate_x }

        it { should eql(coordinate_x) }
      end

      context 'sets placed_coordinate_x' do
        let(:coordinate_y) { 2 }

        subject { board.placed_coordinate_y }

        it { should eql(coordinate_y) }
      end
    end

    context 'with invalid x coordinate' do
      let(:coordinate_x) { 5 }

      it { should eql(false) }
    end

    context 'with invalid y coordinate' do
      let(:coordinate_y) { 5 }

      it { should eql(false) }
    end
  end
end
