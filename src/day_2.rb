# frozen_string_literal: true

class Program
  attr_reader :program

  def initialize(program_source)
    @program = program_source.split(',').map(&:to_i)
  end
end

class Memory
  def initialize(program)
    @value = program.program.clone
  end

  def get(position)
    raise 'Invalid memory access' if position >= size

    @value[position]
  end

  def set(position, value)
    raise 'Invalid memory access' if position >= size

    @value[position] = value
  end

  def dump
    @value.join(',')
  end

  def size
    @value.size
  end
end

class Instruction
  attr_reader :opcode

  def initialize(opcode, computer)
    @opcode = opcode
    @computer = computer
  end

  def param(idx)
    memory = @computer.memory
    current_ptr = @computer.instruction_pointer

    memory.get(current_ptr + idx)
  end

  # Returns the value of a param ptr
  # Example:
  # Layout: 1 2 3 4
  # param: 1 (which is equal to 2)
  # return value: 3
  def param_ptr(idx)
    memory = @computer.memory
    memory.get(param(idx))
  end

  def execute
    raise "Unknown instruction with opcode #{@opcode}"
  end
end

class AddInstruction < Instruction
  def initialize(computer)
    super(1, computer)
  end

  def execute
    memory = @computer.memory

    value1 = param_ptr(1)
    value2 = param_ptr(2)
    return_addr = param(3)

    memory.set(return_addr, value1 + value2)

    @computer.increase_pointer(4)
  end
end

class MultiplyInstruction < Instruction
  def initialize(computer)
    super(2, computer)
  end

  def execute
    memory = @computer.memory

    value1 = param_ptr(1)
    value2 = param_ptr(2)
    return_addr = param(3)

    memory.set(return_addr, value1 * value2)
    @computer.increase_pointer(4)
  end
end

class ExitInstruction < Instruction
  def initialize(computer)
    super(99, computer)
  end

  def execute
    @computer.exit
  end
end


class Computer
  attr_reader :memory, :instruction_pointer

  def initialize(program)
    @program = program
    load_program(program)
    @instruction_pointer = 0
    @instructions = [AddInstruction.new(self),
                     MultiplyInstruction.new(self),
                     ExitInstruction.new(self)]
    @exit = false
  end

  def load_program(program)
    @memory = Memory.new(program)
  end

  def reset_memory
    @instruction_pointer = 0
    @exit = false
    load_program(@program)
  end

  def increase_pointer(amount)
    @instruction_pointer += amount

    # Handle memory overflow
    @instruction_pointer -= @memory.size if @instruction_pointer >= @memory.size
  end

  def current
    @memory.get(@instruction_pointer)
  end

  def exit
    @exit = true
  end

  def run
    until @exit
      opcode = current
      instruction = @instructions.find { |ins| ins.opcode == opcode }

      raise "Cannot find instruction with opcode #{opcode}" if instruction.nil?

      instruction.execute
    end
  end
end


if $PROGRAM_NAME == __FILE__
  file = File.join(File.dirname(__FILE__), 'day_2.txt')
  input = File.read(file)

  program = Program.new(input)
  computer = Computer.new(program)

  # Prepare the 1202 program alert
  computer.memory.set(1, 12)
  computer.memory.set(2, 2)
  computer.run
  puts "Result for 1202 alert #{computer.memory.dump}"


  required_output = 19_690_720
  iterations = 99

  solution = (0..iterations).any? do |noun|
    (0..iterations).any? do |verb|
      computer.reset_memory
      memory = computer.memory

      memory.set(1, noun)
      memory.set(2, verb)
      computer.run

      output = memory.get(0)
      if output == required_output
        solution = 100 * noun + verb
        puts "Found solution noun=#{noun}, verb=#{verb}, solution=#{solution}"
        solution
      else
        puts "(#{noun}, #{verb}) results to #{output}"
      end
    end
  end

  unless solution
    puts 'Could not not find result'
  end
end