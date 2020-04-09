class Unit
  attr_accessor :map_sprite
  
  def initialize(
    dimensioner: MapSprite.map_spr_dms,
    sprite: nil
  )
    @map_sprite = MapSprite.new(
      dimensioner: dimensioner,
      sprite: sprite
    )
  end

  def draw
    map_sprite.draw
  end
end