require_relative '../../mvGraph/lib/mvGraph.rb'
class Grid < Vertex
  include Enumerable
  attr_reader :x, :y

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

  def next_states
    states = []
    # get the x, y for the nil block and move all surrounding squares into it
    # for the next states

  end

  def to_s
    @rows.each do |row|
      row.each do |col|
	print "#{col} "
      end
      puts
    end
  end

  def each
    @rows.each do |row|
      row.each do |col|
	yield col
      end
    end
  end

  def ==(other_grid)
    result = false
    if other_grid.x == @x && other_grid.y == @y 
      result = true
      for y in 0...other_grid.y do
        for x in 0...other_grid.x do
           unless other_grid.block(x, y) == self.block(x, y)
	     result = false
	   end
	end
      end
    end
    result
  end

  def eql?(other_grid)
    result = false
    if other_grid.x == @x && other_grid.y == @y 
      result = true
      for y in 0...other_grid.y do
        for x in 0...other_grid.x do
           unless other_grid.block(x, y) == self.block(x, y)
	     result = false
	   end
	end
      end
    end
    result
  end 

  #def randomize
  #end
end
