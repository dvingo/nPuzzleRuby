require 'minitest/autorun'
require_relative '../lib/grid.rb'
require_relative '../lib/block.rb'

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
    blocks << Block.new(nil)
    @grid = Grid.new(3, 3, blocks)
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
    assert_equal @grid.block(2, 2), Block.new(nil)
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

  def test_randomize
    @grid.randomize
    refute @grid.block(0, 0) == Block.new(1) and
    @grid.block(1, 0) == Block.new(2) and
    @grid.block(2, 0) == Block.new(3) and
    @grid.block(0, 1) == Block.new(4) and
    @grid.block(1, 1) == Block.new(5) and
    @grid.block(2, 1) == Block.new(6) and
    @grid.block(0, 2) == Block.new(7) and 
    @grid.block(1, 2) == Block.new(8) and
    @grid.block(2, 2) == Block.new(nil)
  end
end
