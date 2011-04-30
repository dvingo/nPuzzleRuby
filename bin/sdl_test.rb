#!/usr/bin/ruby
require 'sdl'
require_relative '../lib/grid.rb'
require_relative '../lib/block.rb'

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

def draw_block(block, dest, font, x, y)
  font.draw_solid(dest, block.number, x, y, 255, 0, 0)
end

def draw_grid(grid, dest, font)
  image_loc = grid.get_image_loc
  image = SDL::Surface.load(image_loc)
  arrangement = grid.arrange(image.w, image.h)

  arrangement.each do |block|
    SDL.blit_surface(image, 0, 0, 0, 0, dest, block[:x], block[:y])
    font.draw_solid_utf8(dest, block[:description][:number].to_s, block[:x], block[:y], 60, 50, 60)
  end
end

def generate_random_start_grid(grid_size, steps)
  start_grid_blocks = Grid.construct_default(grid_size)
  start_grid = Grid.new(grid_size, grid_size, start_grid_blocks)
  start_graph = Graph.new
  start_graph.add_vertex(start_grid)
  walk_result = start_graph.walk_n_steps(start_grid, :random_next_states, steps)
  walk_result[0]
end

def make_start_grid(grid_size)
  start_grid_blocks = Grid.construct_default(grid_size)
  start_grid = Grid.new(grid_size, grid_size, start_grid_blocks)
end

SCREEN_HEIGHT = 600
SCREEN_WIDTH = 800
SDL.init(SDL::INIT_VIDEO)
SDL::TTF.init
font = SDL::TTF.open('LiberationMono-Regular.ttf', 32, 0)
client_info = SDL::Screen.info
bpp = client_info.bpp
screen = SDL::Screen.open(SCREEN_WIDTH, SCREEN_HEIGHT, bpp, SDL::SWSURFACE)
SDL::WM.set_caption("N-Puzzle Solver", "")

goal_grid = make_start_grid(4)
start_grid = generate_random_start_grid(4, 3)
new_graph = Graph.new
new_graph.add_vertex(start_grid)
puts "start_grid: #{start_grid}"
new_graph.search(start_grid, "lifo", :next_states_ordered_by_manhattan_distance, goal_grid, nil)

solved_path = new_graph.shortest_path(start_grid, goal_grid)
puts "got here 6"
solved_path.each do |step|
  #puts "step: #{step}"
  #draw_grid(step, screen, font)
  #screen.flip
  #sleep 2
end
#grid = Grid.new(grid_size, grid_size, goal_grid_blocks)
#graph = Graph.new
#graph.add_vertex(grid)
#last_step = [grid, 0]
#for i in 0..10 do
#  walk_result = graph.walk_n_steps(last_step[0], :random_next_states, 1)
#  draw_grid(walk_result[0], screen, font)
#  screen.flip
#  sleep 2
#  last_step = walk_result
#end

while true
  while event = SDL::Event.poll
    case event
    when SDL::Event::KeyDown, SDL::Event::Quit
      font.close
      exit
    when SDL::Event::MouseMotion
      x = event.x
      y = event.y
      #puts "x: #{x}, y: #{y}"
    when SDL::Event::MouseButtonDown
      x = event.x
      y = event.y
      #puts "x: #{x}, y: #{y}"
    end
  end

  sleep 0.05
end
