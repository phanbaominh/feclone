module Spritable
  def draw(x = nil, y = nil, z = nil, scale_x: GC::SCALING_FACTOR, scale_y: GC::SCALING_FACTOR)
    3ds = dms ? dms.get_3d : [x, y, z]
    super(*3ds, scale_x, scale_y)
  end

  def height_grid
    height / 16
  end

  def width_grid
    width / 16
  end
end

class Gosu::Image
  include Dimensionable
  attr_accessor :dms
  prepend Spritable
end

Sprite = Gosu::Image
