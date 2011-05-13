require 'sdl'
require_relative '../lib/grid.rb'
require_relative '../lib/block.rb'

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

def make_start_grid(grid_size)
  start_grid_blocks = Grid.construct_default(grid_size)
  start_grid = Grid.new(grid_size, grid_size, start_grid_blocks)
end

def sdl_init
  screen_height = 600
  screen_width = 800
  SDL.init(SDL::INIT_VIDEO)
  SDL::TTF.init
  @font = SDL::TTF.open('LiberationMono-Regular.ttf', 32, 0)
  client_info = SDL::Screen.info
  bpp = client_info.bpp
  @screen = SDL::Screen.open(screen_width, screen_height, bpp, SDL::SWSURFACE)
  SDL::WM.set_caption("15-Puzzle Solver", "")
end

def display_goal_grid
  grid_size = 4
  @goal_grid = make_start_grid(grid_size)
  draw_grid(@goal_grid, @screen, @font)
  @screen.flip
end

def game_loop
  while true
    while event = SDL::Event.poll
      case event
      when SDL::Event::KeyDown, SDL::Event::Quit
	@font.close
	return
      when SDL::Event::MouseMotion
	x = event.x
	y = event.y
	@goal_grid.each do |block|
	  if x < block.x + block.width and x > block.x \
	      and y < block.y + block.height and y > block.y 
            puts "In block: #{block}"
	  end
	end
      when SDL::Event::MouseButtonDown
	x = event.x
	y = event.y
      end
    end
    sleep 0.05
  end
end

sdl_init
display_goal_grid
game_loop
