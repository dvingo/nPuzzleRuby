require_relative '../../mvGraph/lib/mvGraph.rb'
class Block < Vertex
  attr_reader :number
  def initialize(number)
    @number = number
  end

  def ==(other_block)
    @number == other_block.number
  end
  
  def eql?(other_block)
    @number == other_block.number
  end

  def hash
    @number.hash
  end
end
