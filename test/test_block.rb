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

  def test_extends_vertex
    b = Block.new(1)
    b.id = 1
    assert b.id == 1
  end
end
