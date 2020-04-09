require 'bundler/setup'
Bundler.require(:default)
require_rel 'code'

class Main < Gosu::Window
  attr_reader :map, :cursor
  def initialize
    super GC::GBA_SCREEN_WIDTH * GC::SCALING_FACTOR,
          GC::GBA_SCREEN_HEIGHT * GC::SCALING_FACTOR
    #@background = Gosu::Image.new("assets/map/test.png", retro: true)
    @cursor = Cursor.new
    @map = Map.new(sprite: Gosu::Image.new("assets/map/test.png", retro: true))
    #@unit = Unit.new(sprite: Gosu::Image.load_tiles("assets/character/map_sprites/eirika.png", 32, 32, retro: true))
  end


  def update
    @cursor.handle_buttons
  end

  def draw
    #background.draw(0, 0, 0, 3, 3)
    cursor.draw
    map.draw
    #@unit.map_sprite.draw
  end
end

Main.new.show