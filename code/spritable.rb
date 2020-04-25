require 'gosu'
module Spritable
  def draw(x = nil, y = nil, z = nil, scale_x: GC::SCALING_FACTOR, scale_y: GC::SCALING_FACTOR)
    ds_3 = dms ? dms.get_3d : [x, y, z]
    super(*ds_3, scale_x, scale_y)
  end

  def height_grid
    height / 16
  end

  def width_grid
    width / 16
  end
end

class Gosu::Image
  attr_accessor :dms
  prepend Spritable
end

Sprite = Gosu::Image