require 'sdl'
require_relative '../../graphMatrix/lib/mvGraph.rb'
class Block
  @@image_loc = "../images/blockWhite.png"
  attr_reader :number
  attr_accessor :x, :y, :height, :width
  def initialize(number)
    @number = number
  end

  # Constructs string id for a block in the form "abxy"
  # where ab is the block number 01, 09, 15 etc, and xy 
  # are the corresponding x and y locations in the grid
  # precondition x and y must be set
  def id
    ret_val = ""
    if @number < 10
      ret_val = "0" + @number.to_s
    else 
      ret_val = @number.to_s
    end
    ret_val += @x.to_s
    ret_val += @y.to_s
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
