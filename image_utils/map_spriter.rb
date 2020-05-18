# frozen_string_literal: true

require 'rmagick'
require_relative 'service'
require_relative 'tiler'
class MapSpriter
  OCO = Magick::OverCompositeOp
  TYPES = %w[left right down up idle wait selected].freeze
  attr_accessor :tileset, :file_path
  def initialize(file_path)
    @file_path = file_path
    @tileset = Tiler.perform(file_path, false, 32, 32)
  end

  def perform
    canvas = Magick::Image.new(32 * 4, 32 * 7) do
      self.background_color = 'Transparent'
    end
    sprite(canvas).write('test.png')
  end

  private

  def sprite(canvas)
    TYPES.each_with_index do |type, i|
      type = (type + '_sprite').to_sym
      canvas = canvas.composite(send(type), 0, i * 32, OCO)
    end
    canvas
  end

  def left_sprite
    make_sprite(1, 4)
  end

  def right_sprite
    make_sprite(1, 4, :flop)
  end

  def down_sprite
    make_sprite(2, 4)
  end

  def up_sprite
    make_sprite(3, 4)
  end

  def selected_sprite
    make_sprite(9, 3)
  end

  def wait_sprite
    make_sprite(5, 3, :quantize, [256, Magick::GRAYColorspace])
  end

  def idle_sprite
    make_sprite(5, 3)
  end

  def make_sprite(si, times, method = nil, args = nil)
    tmp = Magick::ImageList.new
    times.times do |i|
      tile = tileset[si + 5 * i]
      if method && args
        tile = tile.send(method, *args)
      elsif method
        tile = tile.send(method)
      end
      tmp << tile
    end
    tmp.append(false)
  end
end
MapSpriter.new('../../assets/character/map_sprites/eirika.png').perform
