require 'minitest/autorun'
require_relative '../lib/grid.rb'
require_relative '../lib/block.rb'
require_relative '../../graphMatrix/lib/mvGraph.rb'

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
    blocks << Block.new(0)
    @grid = Grid.new(3, 3, blocks)
  end

  def setup_4x4
    blocks = []
    blocks << Block.new(1)
    blocks << Block.new(2)
    blocks << Block.new(3)
    blocks << Block.new(4)

    blocks << Block.new(5)
    blocks << Block.new(6)
    blocks << Block.new(7)
    blocks << Block.new(8)

    blocks << Block.new(9)
    blocks << Block.new(10)
    blocks << Block.new(0)
    blocks << Block.new(11)

    blocks << Block.new(13)
    blocks << Block.new(14)
    blocks << Block.new(15)
    blocks << Block.new(12)
    @grid_4x4 = Grid.new(4, 4, blocks)
  end

  def setup_solvable_goal_state_4x4
    blocks = []
    blocks << Block.new(1)
    blocks << Block.new(2)
    blocks << Block.new(3)
    blocks << Block.new(4)

    blocks << Block.new(5)
    blocks << Block.new(6)
    blocks << Block.new(7)
    blocks << Block.new(8)

    blocks << Block.new(9)
    blocks << Block.new(10)
    blocks << Block.new(11)
    blocks << Block.new(12)

    blocks << Block.new(13)
    blocks << Block.new(14)
    blocks << Block.new(15)
    blocks << Block.new(0)
    @solvable_goal_4x4 = Grid.new(4, 4, blocks)
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
    blocks << Block.new(0)
    blocks << Block.new(8)
    @bfs_grid = Grid.new(3, 3, blocks)
  end
  
  def setup_alternate_grid
    blocks = []
    blocks << Block.new(0)
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
    blocks << Block.new(0)
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
    assert_equal @grid.block(2, 2), Block.new(0)
  end

  def test_construct_default_grid
    #grid = Grid.construct_default(3)
    #assert grid
    #assert_equal grid.block(0, 0), Block.new(1), "1"
    #assert_equal grid.block(1, 0), Block.new(2), "2"
    #assert_equal grid.block(2, 0), Block.new(3), "3"
    #assert_equal grid.block(0, 1), Block.new(4), "4"
    #assert_equal grid.block(1, 1), Block.new(5), "5"
    #assert_equal grid.block(2, 1), Block.new(6), "6"
    #assert_equal grid.block(0, 2), Block.new(7), "7"
    #assert_equal grid.block(1, 2), Block.new(8), "8"
    #assert_equal grid.block(2, 2), Block.new(0), "9"

    #grid = Grid.construct_default(4)
    #assert grid
    #assert_equal grid.block(0, 0), Block.new(1), "1a"
    #assert_equal grid.block(1, 0), Block.new(2), "2a"
    #assert_equal grid.block(2, 0), Block.new(3), "3a"
    #assert_equal grid.block(3, 0), Block.new(4), "4a"
    #assert_equal grid.block(0, 1), Block.new(5), "55"
    #assert_equal grid.block(1, 1), Block.new(6), "66"
    #assert_equal grid.block(2, 1), Block.new(7), "77"
   # assert_equal grid.block(3, 1), Block.new(8), "88"
   # assert_equal grid.block(0, 2), Block.new(9), "99"
    #assert_equal grid.block(1, 2), Block.new(10), "10"
    #assert_equal grid.block(2, 2), Block.new(11), "11"
    #assert_equal grid.block(3, 2), Block.new(12), "12"
    #assert_equal grid.block(0, 3), Block.new(13), "123"
    #assert_equal grid.block(1, 3), Block.new(14), "14"
    #assert_equal grid.block(2, 3), Block.new(15), "15"
    #assert_equal grid.block(3, 3), Block.new(0), "16"
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
      refute state.block(2, 2) == Block.new(0), "Grid location 2, 2 should not be 0 for each state returned from next_states."
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
    blocks << Block.new(0)
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
    blocks2 << Block.new(0)
    other_grid2 = Grid.new(3, 3, blocks2)
    assert @grid == other_grid, "Grids are not equal when they should be."
    assert @grid.eql?(other_grid), "Grids are not equal when they should be."
    refute @grid == other_grid2, "Grids are equal when they are two different grids."
    refute @grid.eql?(other_grid2), "Grids are equal when they are two different grids."
  end

  def test_bfs_puzzle_search
    #setup_bfs_grid
    #setup_alternate_grid
    setup_4x4
    setup_solvable_goal_state_4x4
    @graph = Graph.new
    @graph.add_vertex(@grid_4x4)
    assert_equal @solvable_goal_4x4, 
                 @graph.search(@grid_4x4, "fifo", :next_states_ordered_by_manhattan_distance, @solvable_goal_4x4)[0],
		 "The @solvable_goal_4x4 should be the solution for this search."
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

  #Eventually loop over a range of distances and run each generator in a separate thread (in parallel)
  def test_grid_generator
    setup_4x4
    #start_grid = @grid
    start_grid = @grid_4x4
    distance = 3
    @graph = Graph.new
    @graph.add_vertex(start_grid)
    walk_result = @graph.walk_n_steps(start_grid, :random_next_states, distance)
    graph2 = Graph.new
    graph2.add_vertex(walk_result[0])
    puts "Start: #{walk_result[0]}"
    puts "Goal: #{start_grid}"
    search_result = graph2.search(walk_result[0], "fifo", :next_states_ordered_by_manhattan_distance, start_grid, nil)
    path = graph2.shortest_path(walk_result[0], start_grid) 
    path.each_with_index do |p, i|
      puts "path[#{i}]: #{p}"
    end
    steps = path.length - 1
    #steps = search_result[-1]
    assert_equal distance, steps, "The number of steps taken to solve the puzzle should be the same as the generated puzzle's distance"
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
    assert Block.new(0) == up.block(2, 1), "Should be able to slide nil up."
    assert_nil down, "Should not be able to slide nil down."
    refute_nil left, "left should not be nil."
    assert_equal Block.new(0), left.block(1, 2), "Should be able to slide nil left."
    assert_nil right, "Should not be able to slide nil right."
  end
end
