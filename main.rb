# typed: true
# frozen_string_literal: true

require 'bundler/setup'
# require 'awesome_print'
require_relative 'code/spritable.rb'
Bundler.require(:default)
require_rel 'code'

class Main < Gosu::Window
  extend T::Sig
  attr_reader :map_handler, :test
  def initialize
    super GC::GBA_SCREEN_WIDTH * GC::SCALING_FACTOR,
          GC::GBA_SCREEN_HEIGHT * GC::SCALING_FACTOR
    map = Map.new(image_path: 'assets/map/test.png')
    cursor = Cursor.new(map: map)
    @map_handler = MapHandler.new(map: map, cursor: cursor)
  end

  def button_down(id)
    return unless Gosu::KB_T == id
    binding.pry
    p 'Resumed'
  end

  def update
    map_handler.handle_buttons
  end

  def draw
    map_handler.draw
  end
end

Main.new.show
