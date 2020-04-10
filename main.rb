require 'bundler/setup'
Bundler.require(:default)
require_rel 'code'

class Main < Gosu::Window
  attr_reader :map_handler
  def initialize
    super GC::GBA_SCREEN_WIDTH * GC::SCALING_FACTOR,
          GC::GBA_SCREEN_HEIGHT * GC::SCALING_FACTOR
    #@background = Gosu::Image.new("assets/map/test.png", retro: true
    map = Map.new(sprite: Gosu::Image.new("assets/map/test.png", retro: true))
    cursor = Cursor.new(map: map)
    @map_handler = MapHandler.new(map: map, cursor: cursor)
    #@unit = Unit.new(sprite: Gosu::Image.load_tiles("assets/character/map_sprites/eirika.png", 32, 32, retro: true))
  end


  def update
    map_handler.handle_buttons
  end

  def draw
    map_handler.draw
  end
end

Main.new.show