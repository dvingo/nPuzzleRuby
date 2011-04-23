require 'minitest/autorun'
require_relative '../lib/grid.rb'
require_relative '../lib/block.rb'
require_relative '../../mvGraph/lib/mvGraph.rb'

class TestGrid < MiniTest::Unit::TestCase
  def setup
    blocks = []
    blocks << Block.new(1)
    blocks << Block.new(2)
    blocks << Block.new(3)
    blocks << Block.new(4)
    blocks << Block.new(5)
    blocks << Block.new(6)
    blocks << Block.new(7)
    blocks << Block.new(8)
    blocks << Block.new(-1)
    @grid = Grid.new(3, 3, blocks)
  end

  def setup_bfs_grid
    blocks = []
    blocks << Block.new(1)
    blocks << Block.new(2)
    blocks << Block.new(3)
    blocks << Block.new(4)
    blocks << Block.new(5)
    blocks << Block.new(6)
    blocks << Block.new(7)
    blocks << Block.new(-1)
    blocks << Block.new(8)
    @bfs_grid = Grid.new(3, 3, blocks)
  end
  
  def setup_alternate_grid
    blocks = []
    blocks << Block.new(-1)
    blocks << Block.new(1)
    blocks << Block.new(2)
    blocks << Block.new(3)
    blocks << Block.new(4)
    blocks << Block.new(5)
    blocks << Block.new(6)
    blocks << Block.new(7)
    blocks << Block.new(8)
    @alternate_grid = Grid.new(3, 3, blocks)
  end
  
  def setup_empty_middle_grid
    blocks = []
    blocks << Block.new(1)
    blocks << Block.new(8)
    blocks << Block.new(7)
    blocks << Block.new(5)
    blocks << Block.new(-1)
    blocks << Block.new(3)
    blocks << Block.new(2)
    blocks << Block.new(4)
    blocks << Block.new(6)
    @empty_middle_grid = Grid.new(3, 3, blocks)	
  end

  def test_create_grid
    assert @grid
    assert_equal @grid.block(0, 0), Block.new(1)
    assert_equal @grid.block(1, 0), Block.new(2)
    assert_equal @grid.block(2, 0), Block.new(3)
    assert_equal @grid.block(0, 1), Block.new(4)
    assert_equal @grid.block(1, 1), Block.new(5)
    assert_equal @grid.block(2, 1), Block.new(6)
    assert_equal @grid.block(0, 2), Block.new(7)
    assert_equal @grid.block(1, 2), Block.new(8)
    assert_equal @grid.block(2, 2), Block.new(-1)
  end

  def test_out_of_bounds_block
    refute @grid.block(100, 100)
    refute @grid.block(0, 100)
    refute @grid.block(1000, 0)
    refute @grid.block(3, 0)
    refute @grid.block(0, 3)
    refute @grid.block(-1, 0)
    refute @grid.block(0, -1)
  end

  def test_next_state
    states = @grid.next_states
    states.each do |state|
      refute state.block(2, 2) == Block.new(-1), "Grid location 2, 2 should not be -1 for each state returned from next_states."
    end
  end

  def test_to_s
    #puts @grid
  end

  def test_equal
    blocks = []
    blocks << Block.new(1)
    blocks << Block.new(2)
    blocks << Block.new(3)
    blocks << Block.new(4)
    blocks << Block.new(5)
    blocks << Block.new(6)
    blocks << Block.new(7)
    blocks << Block.new(8)
    blocks << Block.new(-1)
    other_grid = Grid.new(3, 3, blocks)
    blocks2 = []
    blocks2 << Block.new(5)
    blocks2 << Block.new(2)
    blocks2 << Block.new(3)
    blocks2 << Block.new(4)
    blocks2 << Block.new(1)
    blocks2 << Block.new(6)
    blocks2 << Block.new(7)
    blocks2 << Block.new(8)
    blocks2 << Block.new(-1)
    other_grid2 = Grid.new(3, 3, blocks2)
    assert @grid == other_grid, "Grids are not equal when they should be."
    assert @grid.eql?(other_grid), "Grids are not equal when they should be."
    refute @grid == other_grid2, "Grids are equal when they are two different grids."
    refute @grid.eql?(other_grid2), "Grids are equal when they are two different grids."
  end

  def test_bfs_puzzle_search
    setup_bfs_grid
    setup_alternate_grid
    @graph = Graph.new
    @graph.add_vertex(@alternate_grid)
    @graph.search(@alternate_grid, "fifo", :next_states_ordered_by_manhattan_distance, @bfs_grid)
  end

  #def test_dfs_puzzle_search
  #  setup_bfs_grid
  #  @graph = Graph.new
  #  @graph.add_vertex(@grid)
  #  @graph.search(@grid, "lifo", :next_states, @bfs_grid)  
  #end

  def test_block_to_loc
    assert_equal 0, @grid.block_to_loc(Block.new(1))[0], "Block 1's x location should be 0."
    assert_equal 0, @grid.block_to_loc(Block.new(1))[1], "Block 1's y location should be 0."
    assert_equal 1, @grid.block_to_loc(Block.new(2))[0], "Block 2's x location should be 1."
    assert_equal 0, @grid.block_to_loc(Block.new(2))[1], "Block 2's y location should be 0."
  end

  def test_manhattan_distance
    setup_bfs_grid 
    setup_alternate_grid
    assert_equal 2, @grid.manhattan_distance(@bfs_grid), "Manhattan distance of @grid and @bfs_grid should be 2."
    assert_equal 16, @grid.manhattan_distance(@alternate_grid), "Manhattan distance of @grid and @alternate_grid should be 16."
  end

  def test_order_next_states_by_manhattan_distance
    #setup_bfs_grid 
    #setup_alternate_grid
    setup_empty_middle_grid
    next_states_ordered = @grid.next_states_ordered_by_manhattan_distance(@grid)
    second_level_ordered = next_states_ordered[0].next_states_ordered_by_manhattan_distance(@grid)
    assert next_states_ordered[0].distance <= next_states_ordered[1].distance, "The order should be lowest to highest for the manhattan order sort."
    assert_equal 0, @grid.manhattan_distance(second_level_ordered[0]), "Manhattan distance of this grid should be 0."
    refute_equal 3, @grid.manhattan_distance(second_level_ordered[0]), "Manhattan distance of this grid should not be 3."

    empty_middle_next_states = @empty_middle_grid.next_states_ordered_by_manhattan_distance(@grid)
    puts "empty_middle_grid: #{@empty_middle_grid}"
    puts "State 0 distance: #{empty_middle_next_states[0].distance}"
    puts "State 1 distance: #{empty_middle_next_states[1].distance}"
    puts "State 2 distance: #{empty_middle_next_states[2].distance}"
    puts "State 3 distance: #{empty_middle_next_states[3].distance}"
    assert empty_middle_next_states[0].distance <= empty_middle_next_states[1].distance, "Distance of first returned state should be least."
    assert empty_middle_next_states[1].distance <= empty_middle_next_states[2].distance, 
      "Distance of second returned state should be less than distance of third returned state"
    assert empty_middle_next_states[2].distance <= empty_middle_next_states[3].distance,
      "Distance of third returned state should be less than distance of fourth returned state"
  end
  
  def test_is_invalid_move?
    assert @grid.is_invalid_move?(2, 2, "down", @grid.rows), "Should be able to slide down from current position (0,0)"
    assert @grid.is_invalid_move?(2, 2, "right", @grid.rows), "Should be able to slide right from current position (0,0)"
    refute @grid.is_invalid_move?(2, 2, "up", @grid.rows), "Shouldn't be able to slide up from current position (0,0)"
    refute @grid.is_invalid_move?(2, 2, "left", @grid.rows), "Shouldn't be able to slide left from current position (0,0)"
    setup_alternate_grid
    assert @alternate_grid.is_invalid_move?(0, 0, "left", @alternate_grid.rows), "Should be able to slide left from current position (8,8)"
    assert @alternate_grid.is_invalid_move?(0, 0, "up", @alternate_grid.rows), "Should be able to slide up from current position (8,8)"
    refute @alternate_grid.is_invalid_move?(0, 0, "right", @alternate_grid.rows), "Shouldn't be able to slide right from current position (8,8)"
    refute @alternate_grid.is_invalid_move?(0, 0, "down", @alternate_grid.rows), "Shouldn't be able to slide down from current position (8,8)"
  end
  
  def test_slide
    temp = @grid.slide("up")
    up = Grid.new(3, 3, temp)
    down = @grid.slide("down")
    temp = @grid.slide("left")
    left = Grid.new(3, 3, temp)
    right = @grid.slide("right")
    
    refute_nil up, "up should not be nil."
    assert Block.new(-1) == up.block(2, 1), "Should be able to slide nil up."
    assert_nil down, "Should not be able to slide nil down."
    refute_nil left, "left should not be nil."
    assert_equal Block.new(-1), left.block(1, 2), "Should be able to slide nil left."
    assert_nil right, "Should not be able to slide nil right."
  end
end
