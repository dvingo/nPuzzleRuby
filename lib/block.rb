require 'sdl'
require_relative '../../mvGraph/lib/mvGraph.rb'
class Block
  @@image_loc = "../images/blockWhite.png"
  attr_reader :number
  attr_accessor :x, :y, :height, :width
  def initialize(number)
    @number = number
  end
  
  def self.image_loc
    @@image_loc
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

  def to_s
    "#{@number}"
  end

  def describe
    values = Hash.new
    values[:number] = @number
    values[:image] = @@image_loc
    values
  end
end
