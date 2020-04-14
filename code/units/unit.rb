class Unit
  include Dimensionable
  attr_accessor :map_sprite, :name
  
  def initialize(
    name: nil,
    dimensioner: MapSprite.map_spr_dms,
    image_path: nil,
    movement: Movement.new
  )
    @map_sprite = MapSprite.new(
      dimensioner: dimensioner,
      image_path: image_path
    )
    @name = name
    @movement = movement
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