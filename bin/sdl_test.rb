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

SCREEN_HEIGHT = 600
SCREEN_WIDTH = 800
SDL.init(SDL::INIT_VIDEO)
SDL::TTF.init
font = SDL::TTF.open('/usr/share/fonts/truetype/DroidSansMono.ttf', 32, 0)
client_info = SDL::Screen.info
bpp = client_info.bpp
screen = SDL::Screen.open(SCREEN_WIDTH, SCREEN_HEIGHT, bpp, SDL::SWSURFACE)
SDL::WM.set_caption("N-Puzzle Solver", "")
image = SDL::Surface.load("../images/blockWhite.png")
puts "font.size_text: #{font.text_size('4')}"
puts "font.height: #{font.height}"
SDL.blit_surface(image, 0, 0, 0, 0, screen, 100, 10)
font.draw_solid_utf8(screen, '4;aldskjfa;lskjf', 105, 10, 60, 50, 60)
screen.flip
while true
  while event = SDL::Event.poll
    case event
    when SDL::Event::KeyDown, SDL::Event::Quit
      font.close
      exit
    when SDL::Event::MouseMotion
      x = event.x
      y = event.y
      puts "x: #{x}, y: #{y}"
    when SDL::Event::MouseButtonDown
      x = event.x
      y = event.y
      puts "x: #{x}, y: #{y}"
    end
  end

  sleep 0.05
end
