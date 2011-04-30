require_relative '../../mvGraph/lib/mvGraph.rb'
class Grid < Vertex
  include Enumerable
  include Comparable
  attr_reader :x, :y, :rows
  attr_accessor :distance

  def initialize(x, y, blocks)
    super(self.object_id)
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

  # Creates a 3x3 or 4x4 grid in left to right top to bottom 
  # numerical order
  def self.construct_default(size)
    blocks = []
    for i in 1..(size**2 - 1) do
      blocks << Block.new(i)
    end
    blocks << Block.new(-1)
    blocks
  end

  # Returns the block at location x, y.  x, y are zero indexed.
  def block(x, y)
    @rows[y][x] unless y >= @y or x >= @x or y < 0 or x < 0
  end

  # Takes a block and returns its x y location in an array.
  def block_to_loc(block)
    @block_to_loc[block]
  end

  # Get the x, y for the nil block and move all surrounding squares into it
  # for the next states
  def next_states
    states = []
    for direction in ["up", "down", "left", "right"] do
        new_rows = slide(direction)
        states << Grid.new(@x, @y, new_rows) unless new_rows.nil?
    end
    states
  end

  def random_next_states
    states = []
    directions = ["up", "down", "left", "right"]
    directions.shuffle!
    for direction in directions do
        new_rows = slide(direction)
        states << Grid.new(@x, @y, new_rows) unless new_rows.nil?
    end
    states
  end
  
  def next_states_ordered_by_manhattan_distance(goal_state)
    return_array = []
    next_states.each do |grid_state|
      grid_state.distance = goal_state.manhattan_distance(grid_state)
      # we'd want to sort on insertion instead of using sort_by
      # return_array.add_in_sorted_order
      return_array << grid_state
    end
    return_array.sort_by! { |state| state.distance }
    return_array
  end

  # Moves the empty square in the direction passed, if it is a valid direction
  def slide(direction)
    x, y = @block_to_loc[Block.new(-1)]
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
  # Performs boundary checks with passed direction
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

  # Returns a number which is the sum of the distances of each block
  # from its current state to its goal state.
  def manhattan_distance(other_grid)
    man_distance = 0
    self.each do |block|
      x, y = @block_to_loc[block] 
      other_x, other_y = other_grid.block_to_loc(block)
      man_distance += (x - other_x).abs + (y - other_y).abs
    end
    man_distance
  end
  
  def to_s
    @rows.each do |row|
      row.each do |col|
	print "#{col} "
      end
      puts
    end
  end

  # Yields each block left to right top to bottom.
  def each
    @rows.each do |row|
      row.each do |col|
	yield col
      end
    end
  end

  def <=>(other_grid)
    self.distance <=> other_grid.distance
  end

  # Two grids are equal if they are the same size and all blocks 
  # are equal by location and corresponding number.
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

  # Same implementation as ==
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

  def get_image_loc
    Block.image_loc
  end

  def arrange(width, height)
    ret_values = Array.new
    @rows.each_with_index do |row, y|
      row.each_with_index do |local_block, x|
        the_x = (x + 1) * width
        the_y = (y + 1) * height
        block_hash = Hash.new
        block_hash[:description] = local_block.describe
        block_hash[:x] = the_x
        block_hash[:y] = the_y
        ret_values << block_hash
      end
    end
    ret_values
  end
end
