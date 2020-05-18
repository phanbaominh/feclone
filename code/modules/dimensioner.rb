# frozen_string_literal: true

class Dimensioner
  attr_accessor :x, :y, :z
  attr_reader :x_grid, :y_grid, :x_offset, :y_offset
  def initialize(x: nil, y: nil, x_grid: 0, y_grid: 0, z: 0, x_offset: 0, y_offset: 0)
    @x_grid = x_grid
    @y_grid = y_grid
    @x = x || real(x_grid) || 0
    @y = y || real(y_grid) || 0
    @z = z
    @x_offset = x_offset
    @y_offset = y_offset
  end

  def x_grid=(value)
    self.x = real(value)
    @x_grid = value
  end

  def y_grid=(value)
    self.y = real(value)
    @y_grid = value
  end

  def get_3d
    [x + x_offset, y + y_offset, z]
  end

  def mutate(value)
    @x = value.x
    @y = value.y
    @x_grid = value.x_grid
    @y_grid = value.y_grid
    @z = value.z
    @x_offset = value.x_offset
    @y_offset = value.y_offset
  end

  def ==(other)
    x_grid == other.x_grid && y_grid == other.y_grid
  end

  private

  def real(dimension)
    dimension * GC::GRID_SIZE
  end
end
