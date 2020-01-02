require 'rspec'
require_relative '../src/day_3'

describe 'day 3' do
  describe Path do
    it 'should be able to parse a path' do
      input = 'U1,L2,D3,R4'
      path = Path.from_s(input)

      expected_parts = [
        PathPart.new(:up,    1),
        PathPart.new(:left,  2),
        PathPart.new(:down,  3),
        PathPart.new(:right, 4)
      ]

      expect(path.parts).to eq(expected_parts)
    end
  end
  describe Coordinate do
    it 'Two coordinates with the same values should be equal to each other' do
      one = Coordinate.new(1,2)
      two = Coordinate.new(1, 2)

      expect(one).to eq(two)
    end
  end
  describe 'examples' do
    class Example
      attr_reader :input, :expected_distance

      def initialize(input, expected_distance)
        @input = input
        @expected_distance = expected_distance
      end
    end

    [
        Example.new(
            "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83",
            159
        ),
        Example.new(
            "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7",
            135
        )
    ].each do |example|
      it "should be able to calculate #{example.input}" do
        result = calculate_distance(example.input)
        expect(result).to be example.expected_distance
      end
    end
  end
end
