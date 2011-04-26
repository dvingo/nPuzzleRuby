require 'sdl'

SDL.init(SDL::INIT_VIDEO)
screen = SDL.setVideoMode(640, 480, 32, SDL::SWSURFACE)
SDL::WM.set_caption("Test", "")
image = SDL::Surface.load_bmp("hello.bmp")
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
