# frozen_string_literal: true

def fuel_required(mass)
  result = (mass / 3).floor - 2

  return 0 if result.negative?

  result + fuel_required(result)
end

if $PROGRAM_NAME == __FILE__
  file = File.join(File.dirname(__FILE__), 'day_1.txt')
  total_fuel = File.foreach(file).map(&:to_i).sum
  puts total_fuel
end