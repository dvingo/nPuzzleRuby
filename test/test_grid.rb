require 'minitest/autorun'
require_relative '../lib/grid.rb'

class TestGrid < MiniTest::Unit::TestCase
  def setup
    @g = Grid.new
    @g.add_vertex(Block.new(1))
    @g.add_vertex(Block.new(2))
    @g.add_vertex(Block.new(3))
    @g.add_vertex(Block.new(4))
    @g.add_vertex(Block.new(nil))
    @g.add_edge(Block.new
  end

  def test_create_grid
    assert @g
  end

  # want grid to have:
  #  a collection of Block with a map to their x,y
  #  move Blocks to new locations
  def test_set

  end

  def 
    assert 
  end
end
