require 'set'

def calculate_minimum_amount_of_steps(input)
  wires = input.split("\n")
               .map { |line| Path.from_s(line) }
               .map { |path| Wire.new(path) }

  first_wire = wires[0]
  second_wire = wires[1]

  intersections = first_wire.find_intersections(second_wire)
  zero = Coordinate.zero

  intersections.filter { |intersection| intersection != zero }
               .map    { |intersection| first_wire.steps(intersection) + second_wire.steps(intersection) }
               .min
end

class Wire
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def find_intersections(other_wire)
    our_coordinates = @path.coordinates
    other_coordinates = other_wire.path.coordinates

    our_coordinates & other_coordinates
  end

  def steps(coordinate)
    @path.steps(coordinate)
  end
end

class Path
  attr_reader :parts

  def initialize(parts)
    @parts = parts
    @coordinates = calculate_coordinates
  end

  def calculate_coordinates
    x = 0
    y = 0
    steps = 0

    coordinates = Hash.new

    parts.each do |part|
      amount = part.amount
      case part.direction
      when :up
        (1..amount).each do |_|
          steps += 1
          y += 1
          coordinates[Coordinate.new(x, y)] = steps
        end
      when :right
        (1..amount).each do |_|
          steps += 1
          x += 1
          coordinates[Coordinate.new(x, y)] = steps
        end
      when :down
        (1..amount).each do |_|
          steps += 1
          y -= 1
          coordinates[Coordinate.new(x, y)] = steps
        end
      when :left
        (1..amount).each do |_|
          steps += 1
          x -= 1
          coordinates[Coordinate.new(x, y)] = steps
        end
      else
        raise 'Unknown direction'
      end
    end

    coordinates
  end

  def self.from_s(input_path)
    parts = input_path.split(',').map { |part| PathPart.from_s(part) }
    Path.new(parts)
  end

  def coordinates
    set = Set[]
    @coordinates.keys.each { |coordinate| set << coordinate }
    set
  end

  def steps(coordinate)
    @coordinates[coordinate]
  end
end

class PathPart
  attr_reader :direction, :amount

  def initialize(direction, amount)
    @direction = direction
    @amount = amount
  end

  def self.from_s(str)
    direction = case str[0]
                when 'U'
                  :up
                when 'L'
                  :left
                when 'D'
                  :down
                when 'R'
                  :right
                else
                  raise 'Unknown direction'
                end
    amount = str[1..-1].to_s.to_i
    PathPart.new(direction, amount)
  end

  def eql?(other)
    self == other
  end

  def ==(other)
    direction == other.direction && direction == other.direction
  end

  def hash
    [direction, amount].hash
  end
end


class Coordinate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def self.zero
    Coordinate.new(0, 0)
  end

  def distance(other)
    (x - other.x).abs + (y - other.y).abs
  end

  def eql?(other)
    self == other
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def hash
    [x, y].hash
  end
end

if $PROGRAM_NAME == __FILE__
  file = File.join(File.dirname(__FILE__), 'day_3.txt')
  input = File.read(file)
  result = calculate_minimum_amount_of_steps(input)

  puts result
end