require 'rspec'
require_relative '../src/day_2.rb'

describe 'day 2' do
  describe Memory do
    before do
      input = '1,2,3,4,5,6,7,8,9,10'
      program = Program.new(input)
      @memory = Memory.new(program)
    end

    it 'can get a position' do
      expect(@memory.get(0)).to be 1
    end

    it 'can update a position' do
      @memory.set(0, 5)
      expect(@memory.get(0)).to be 5
    end

    it 'should raise an error if trying to access non-existing memory' do
      size = @memory.size
      expect { @memory.get(size) }.to raise_error('Invalid memory access')
      expect { @memory.set(size, 1) }.to raise_error('Invalid memory access')
    end
  end

  describe Computer do
    describe 'can correctly run the example programs' do
      [
        ['1,0,0,0,99',          '2,0,0,0,99'],
        ['2,3,0,3,99',          '2,3,0,6,99'],
        ['2,4,4,5,99,0',        '2,4,4,5,99,9801'],
        ['1,1,1,4,99,5,6,0,99', '30,1,1,4,2,5,6,0,99'],
      ].each do |input, output|
        it "Running #{input}" do
          program = Program.new(input)
          computer = Computer.new(program)

          computer.run

          expect(computer.memory.dump).to eq(output)
        end
      end
    end
  end
end

