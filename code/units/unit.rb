class Unit
  include Dimensionable
  attr_accessor :map_sprite, :name, :movement
  
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

  def change_ani_state(state: state)
    map_sprite.ani_state = state
  end

  def change_sprite_state(state:)
    change_ani_state(state: state)
    change_highlighter_state(state: state)
  end
  
  def change_move_state(move:, cursor_terrain:)
    change_ani_state(state: move) if map_sprite.ani_state != move && map_sprite.arrow.length == 0
    change_arrow(move: move, cursor_terrain: cursor_terrain)
  end

  def change_arrow(move:, cursor_terrain:)
    map_sprite.arrow.setup_arrow(move: move)
  end

  def clear_arrow
    map_sprite.arrow.clear
  end

  def change_highlighter_state(state:)
    map_sprite.highlighter_offset = movement.value
    map_sprite.highlighter_state = state
  end

  def add_moveable_tiles(moveable_tiles:)
    map_sprite.movable_tiles = moveable_tiles if !map_sprite.movable_tiles
  end
end