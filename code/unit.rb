class Unit
  include Dimensionable
  attr_accessor :map_sprite, :name
  
  def initialize(
    name: nil,
    dimensioner: MapSprite.map_spr_dms,
    sprite: nil
  )
    @map_sprite = MapSprite.new(
      dimensioner: dimensioner,
      sprite: sprite
    )
    @name = name
  end

  def draw
    map_sprite.draw
  end
  
  def get_placeholder_name
    "Name" + map_sprite.dimensioner.x_grid.to_s + map_sprite.dimensioner.y_grid.to_s
  end

  def inspect
    name || get_placeholder_name
  end

  def to_s
    name || get_placeholder_name
  end

  def dimensioner
    map_sprite.dimensioner
  end

  def change_ani_state(state)
    map_sprite.ani_state = state
  end
end