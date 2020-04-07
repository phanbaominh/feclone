require 'bundler/setup'
Bundler.require(:default)
require_rel 'code'

class Main < Gosu::Window
  Z_CURSOR = 1
  IMAGE_CURSOR = Gosu::Image.load_tiles("assets/map_ui/cursor.png", 32, 32, retro: true)[0]
  GRID_SIZE = 48
  attr_reader :background, :eirika

  def initialize
    super 720, 480
    @background = Gosu::Image.new("assets/map/test.png", retro: true)
    @eirika = Gosu::Image.load_tiles("assets/character/map_sprites/eirika.png", 33, 33, retro: true)
    p @eirika.size
    @time = 0
    @wait = 500
    @cur = 5
    @reverse = false
    @cursor = Cursor.new
  end

  def time_since_last(time)
    Gosu::milliseconds - time
  end

  def update
    @cursor.button_handle()
  end

  def draw
    background.draw(0, 0, 0, 3, 3)
    if time_since_last(@time) > @wait
      @time = Gosu::milliseconds
      if @wait == 500
        @wait = 50
      else
        @wait = 500
      end

      !@reverse ? @cur += 5 : @cur -=5 
      @reverse = !@reverse if @cur == 5 || @cur == 15
    end
    eirika_ins = @eirika[@cur].draw(600,300,2,3,3)
    @cursor.draw
  end
  
end

Main.new.show