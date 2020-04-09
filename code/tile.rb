class Tile
  attr_accessor :dimensioner
  attr_reader :unit

  def initialize(
      unit: nil,
      dimensioner: Dimensioner.new
  )
    @dimensioner = dimensioner
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
    unit.map_sprite.dimensioner = MapSprite.map_spr_dms(x: dimensioner.x_grid, y: dimensioner.y_grid) if unit
  end

end