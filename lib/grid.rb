require_relative '../../mvGraph/lib/mvGraph.rb'
class Grid < Vertex
  include Enumerable
  attr_reader :x, :y
  attr_reader :rows
  def initialize(x, y, blocks)
    @x = x
    @y = y
    @rows = Array.new(@y) { Array.new }
    k = 0
    @block_to_loc = Hash.new
    blocks.each_with_index do |block, i|
      # increment y (k) if x (i) is at the end of the row
      k += 1 if i % @x == 0 and i != 0 
      @rows[k] << block 
      @block_to_loc[block] = [i % @x, k]
    end
  end

  def block(x, y)
    @rows[y][x] unless @rows.size() - 1 < y or @rows[y].size() - 1 < x or y < 0 or x < 0
  end

  # Get the x, y for the nil block and move all surrounding squares into it
  # for the next states
  # TODO probably should make this an instance method that takes a grid and returns
  #      next states
  def next_states
    states = []
    for direction in ["up", "down", "left", "right"] do
        new_rows = slide(direction)
        states << Grid.new(@x, @y, new_rows) unless new_rows.nil?
    end
    states
  end

  # Class method
  def self.next_states
    Proc.new do |grid|
      states = []
      for direction in ["up", "down", "left", "right"] do
        new_rows = slide2(direction, grid)
        states << Grid.new(@x, @y, new_rows) unless new_rows.nil?
      end
      states
    end
  end

  def self.fill_block_to_loc
  end
  
  def self.slide2(direction, grid)
    x,y = @block_to_loc[Block.new(-1)]
    # Marshal is needed to perform a deep copy of the object
    new_rows = Marshal::load(Marshal.dump(grid.rows))
    return_nil = true
    unless is_invalid_move?(x, y, direction, new_rows)
      return_nil = false
      case direction
      when "up"
        new_rows[y][x] = new_rows[y-1][x]
        new_rows[y-1][x] = Block.new(-1)
      when "down"
        new_rows[y][x] = new_rows[y+1][x]
        new_rows[y+1][x] = Block.new(-1)
      when "left"
        new_rows[y][x] = new_rows[y][x-1]
        new_rows[y][x-1] = Block.new(-1)
      when "right"
        new_rows[y][x] = new_rows[y][x+1]
        new_rows[y][x+1] = Block.new(-1)
      end
    end
    if return_nil == false
      return new_rows.flatten 
    else
      return nil
    end
  end

  def slide(direction)
    x,y = @block_to_loc[Block.new(-1)]
    # Marshal is needed to perform a deep copy of the object
    new_rows = Marshal::load(Marshal.dump(@rows))
    return_nil = true
    unless is_invalid_move?(x, y, direction, new_rows)
      return_nil = false
      case direction
      when "up"
        new_rows[y][x] = new_rows[y-1][x]
        new_rows[y-1][x] = Block.new(-1)
      when "down"
        new_rows[y][x] = new_rows[y+1][x]
        new_rows[y+1][x] = Block.new(-1)
      when "left"
        new_rows[y][x] = new_rows[y][x-1]
        new_rows[y][x-1] = Block.new(-1)
      when "right"
        new_rows[y][x] = new_rows[y][x+1]
        new_rows[y][x+1] = Block.new(-1)
      end
    end
    if return_nil == false
      return new_rows.flatten 
    else
      return nil
    end
  end
  
  #
  #TODO refactor with less awkward syntax
  #
  def is_invalid_move?(x, y, direction, new_rows)
    return true if x == 0 and direction == "left"
    return true if y == 0 and direction == "up"
    return true if x == @x - 1 and direction == "right"
    return true if y == @y - 1 and direction == "down"
    return true if direction == "up" and y - 1 > 0 and new_rows[y-1][x] == Block.new(-1)
    return true if direction == "down" and y < @y - 1 and new_rows[y+1][x] == Block.new(-1)
    return true if direction == "left" and x - 1 > 0 and new_rows[y][x-1] == Block.new(-1)
    return true if direction == "right" and x < @x - 1 and new_rows[y][x+1] == Block.new(-1)
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
  # example to generate random numbers:  10.times.map { Random.new.rand(0..10) }    
  #end
end
