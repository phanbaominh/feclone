require 'bundler/setup'
Bundler.require(:default)
require_rel 'code'

class Main < Gosu::Window
  attr_reader :background, :eirika
  def initialize
    super 720, 480
    @background = Gosu::Image.new("assets/map/test.png", retro: true)
    @cursor = Cursor.new
  end


  def update
    @cursor.handle_buttons
  end

  def draw
    background.draw(0, 0, 0, 3, 3)
    @cursor.draw
  end
  
end

Main.new.show