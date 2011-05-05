require_relative '../../mvGraph/lib/mvGraph.rb'
class Grid < Vertex
  include Enumerable
  include Comparable
  attr_reader :x, :y, :rows, :id
  attr_accessor :distance

  def initialize(x, y, blocks)
    super(self.object_id)
    @x = x
    @y = y
    @rows = Array.new(@y) { Array.new }
    k = 0
    # A grid's Id is a string comprised of each block's number (zero padded),
    # plus the x and y location of that block, this way we can quickly determine equality
    # by comparing strings instead of all the blocks in the grid.
    @id = ""
    @block_to_loc = Hash.new
    blocks.each_with_index do |block, i|
      # increment y (k) if x (i) is at the end of the row
      k += 1 if i % @x == 0 and i != 0 
      block.x = i % @x
      block.y = k
      @rows[k] << block 
      puts "block id: #{block.id}"
      @block_to_loc[block] = [i % @x, k]
      if block.number < 10
        @id += "0" + block.number.to_s + (i % @x).to_s + k.to_s
      else
      	@id += block.number.to_s + (i % @x).to_s + k.to_s
      end
    end
  end

  # Creates a 3x3 or 4x4 grid in left to right top to bottom 
  # numerical order
  def self.construct_default(size)
    blocks = []
    for i in 1..(size**2 - 1) do
      blocks << Block.new(i)
    end
    blocks << Block.new(0)
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

  # swaps the block at x, y with the block next to it in the direction indicated
  # changes the values in place in the 2d array rows 
  def swap_blocks(x, y, direction, rows)
    case direction
    when "up"
      rows[y][x] = rows[y-1][x]
      rows[y][x].x = x
      rows[y][x].y = y
      rows[y-1][x] = Block.new(0)
      rows[y-1][x].x = x 
      rows[y-1][x].y = y-1
    when "down"
      rows[y][x] = rows[y+1][x]
      rows[y][x].x = x
      rows[y][x].y = y
      rows[y+1][x] = Block.new(0)
      rows[y+1][x].x = x 
      rows[y+1][x].y = y+1
    when "left"
      rows[y][x] = rows[y][x-1]
      rows[y][x].x = x
      rows[y][x].y = y
      rows[y][x-1] = Block.new(0)
      rows[y][x-1].x = x-1 
      rows[y][x-1].y = y
    when "right"
      rows[y][x] = rows[y][x+1]
      rows[y][x].x = x
      rows[y][x].y = y
      rows[y][x+1] = Block.new(0)
      rows[y][x+1].x = x+1 
      rows[y][x+1].y = y
    end
  end

  # Moves the empty square in the direction passed, if it is a valid direction
  def slide(direction)
    x, y = @block_to_loc[Block.new(0)]
    # Marshal is needed to perform a deep copy of the object
    new_rows = Marshal::load(Marshal.dump(@rows))
    return_nil = true
    unless is_invalid_move?(x, y, direction, new_rows)
      return_nil = false
      block_id = block(x, y).id
      block_index = @id.index(block_id)
      case direction
      when "up"
	other_block_id = block(x, y-1).id
      when "down"
	other_block_id = block(x, y+1).id
      when "left"
	other_block_id = block(x-1, y).id
      when "right"
	other_block_id = block(x+1, y).id
      end
      other_block_index = @id.index(other_block_id) 
      # if block_index is first copy other_block's id first so we can still overwrite current_block's id after
      if block_index < other_block_index
	@id.sub!(other_block_id, block_id)
	@id.sub!(block_id, other_block_id)
      else
	@id.sub!(block_id, other_block_id)
	@id.sub!(other_block_id, block_id)
      end
      swap_blocks(x, y, direction, new_rows)
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
    return true if direction == "up" and y - 1 > 0 and new_rows[y-1][x] == Block.new(0)
    return true if direction == "down" and y < @y - 1 and new_rows[y+1][x] == Block.new(0)
    return true if direction == "left" and x - 1 > 0 and new_rows[y][x-1] == Block.new(0)
    return true if direction == "right" and x < @x - 1 and new_rows[y][x+1] == Block.new(0)
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
    return @id == other_grid.id
    #result = false
    #if other_grid.x == @x && other_grid.y == @y 
    #  result = true
    #  for y in 0...other_grid.y do
    #    for x in 0...other_grid.x do
    #       unless other_grid.block(x, y) == self.block(x, y)
   # 	     result = false
   #      break
   # 	   end
   # 	end
   #   end
   # end
   # result
  end

  # Same implementation as ==
  def eql?(other_grid)
    return @id == other_grid.id
    #return @id == other_grid.id
    #result = false
    #if other_grid.x == @x && other_grid.y == @y 
    #  result = true
    #  for y in 0...other_grid.y do
    #    for x in 0...other_grid.x do
    #       unless other_grid.block(x, y) == self.block(x, y)
#	     result = false
#	     break
#	   end
#	end
#      end
#    end
#    result
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
