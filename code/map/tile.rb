# frozen_string_literal: true

class Tile
  attr_accessor :dms
  attr_reader :unit
  TERRAINS = {
    plain: Terrain.get_terrain(name: :plain),
    hill: Terrain.get_terrain(name: :hill),
    forest: Terrain.get_terrain(name: :forest),
    cliff: Terrain.get_terrain(name: :cliff),
    sea: Terrain.get_terrain(name: :sea),
    fort: Terrain.get_terrain(name: :fort),
    village: Terrain.get_terrain(name: :village),
    default: Terrain.get_terrain(name: :default)
  }.freeze
  def initialize(
    unit: nil,
    dimensioner: Dimensioner.new,
    terrain: :default
  )
    @dms = dimensioner
    @terrain = TERRAINS[terrain]
    if unit
      @unit = unit
      set_unit_dms
    end
  end

  def unit=(value)
    @unit = value
    set_unit_dms
  end

  def draw
    unit&.draw
  end

  private

  def set_unit_dms
    if unit
      unit.map_sprite.dms = MapSprite.map_spr_dms(x: dms.x_grid, y: dms.y_grid)
    end
  end
end
