require 'minitest/autorun'
require_relative '../lib/block.rb'

class TestBlock < MiniTest::Unit::TestCase
  def test_get_block_number
    b = Block.new(1)
    assert_equal 1, b.number
  end

  def test_number_immutable
    b = Block.new(1)
    refute b.respond_to? :number= 
  end

  def test_equals
    b1 = Block.new(1)
    b2 = Block.new(1)
    assert b1 == b2
    assert b1.eql? b2
    assert_equal b1, b2
  end

  def test_access_x_y
    b = Block.new(1)
    b.x = 0
    b.y = 3
    assert_equal 0, b.x, "Block's x should be 0"
    assert_equal 3, b.y, "Block's y should be 3"
  end

  def test_id
    b = Block.new(1)
    b.x = 0
    b.y = 3
    assert_equal "0103", b.id, "Block's id should be 0103"
    b2 = Block.new(10)
    b2.x = 0
    b2.y = 3
    assert_equal "1003", b2.id, "Block's id should be 1003"
  end
end
