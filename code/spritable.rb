# typed: true
# frozen_string_literal: true

require 'gosu'
module Spritable
  attr_accessor :dms
  def draw(
    x = nil, y = nil, z = nil,
    scale_x: GC::SCALING_FACTOR, scale_y: GC::SCALING_FACTOR
  )
    ds3 = dms ? dms.xyz : [x, y, z]
    super(*ds3, scale_x, scale_y)
  end

  def height_grid
    T.let(height, Integer) / 16
  end

  def width_grid
    T.let(width, Integer) / 16
  end
end

module Gosu
  class Image
    prepend Spritable
  end
end

Sprite = Gosu::Image
