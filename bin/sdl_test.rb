require 'sdl'
require_relative '../lib/grid.rb'

SCREEN_HEIGHT = 600
SCREEN_WIDTH = 800
SDL.init(SDL::INIT_VIDEO)
client_info = SDL::Screen.info
bpp = client_info.bpp
screen = SDL::Screen.open(SCREEN_WIDTH, SCREEN_HEIGHT, bpp, SDL::SWSURFACE)
SDL::WM.set_caption("N-Puzzle Solver", "")
image = SDL::Surface.load_bmp("../images/hello.bmp")
SDL.blit_surface(image, 0, 0, 0, 0, screen, 100, 10)
screen.flip
while true
  while event = SDL::Event.poll
    case event
    when SDL::Event::KeyDown, SDL::Event::Quit
      exit
    end
  end

  sleep 0.05
end
