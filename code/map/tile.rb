class Tile
  attr_accessor :dms
  attr_reader :unit

  def initialize(
      unit: nil,
      dimensioner: Dimensioner.new,
      terrain: :default
  )
    @dms = dimensioner
    @terrain = Terrain.get_terrain(name: terrain)
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
    unit.draw if unit
  end
  
  
  private

  def set_unit_dms
    unit.map_sprite.dms = MapSprite.map_spr_dms(x: dms.x_grid, y: dms.y_grid) if unit
  end

end