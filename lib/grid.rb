require_relative '../../mvGraph/lib/mvGraph.rb'
class Grid < Vertex
  def initialize(x, y, blocks)
    @x = x
    @y = y
    @rows = Array.new(@y) { Array.new }
    k = 0
    blocks.each_with_index do |block, i|
      # increment y (k) if x (i) is at the end of the row
      k += 1 if i % @x == 0 and i != 0 
      @rows[k] << block 
    end
  end

  def block(x, y)
    @rows[y][x] unless @rows.size()-1 < y or @rows[y].size() - 1 < x or y < 0 or x < 0
  end

  def randomize
      
  end
end
