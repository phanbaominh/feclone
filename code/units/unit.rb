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
      image_path: image_path,
      move_count: movement.value
    )
    @name = name
    @movement = movement
  end

  def draw
    map_sprite.draw
  end
  
  def get_placeholder_name
    "Name" + map_sprite.dms.x_grid.to_s + map_sprite.dms.y_grid.to_s
  end

  def inspect
    name || get_placeholder_name
  end

  def to_s
    name || get_placeholder_name
  end

  def dms
    map_sprite.dms
  end

  def change_ani_state(state: state)
    map_sprite.ani_state = state
  end

  def change_sprite_state(state:)
    change_ani_state(state: state)
    change_highlighter_state(state: state)
  end
  
  def change_move_state(move:, cursor_terrain:, dms:)
    change_ani_state(state: move) if map_sprite.ani_state != move && map_sprite.arrow.length == 0

    move_cost = cursor_terrain.move_cost(movement.type)
    arrow = map_sprite.arrow
    j = dms.y_grid + movement.value - y_grid
    i = dms.x_grid + movement.value - x_grid
    tile_route = map_sprite.movable_tiles[j][i]
    
    if !tile_route
      arrow.out_of_range = true
      return
    end
    
    if arrow.opposite_direction?(arrow.last_move, move)
      move_cost = -move_cost
    end

    if arrow.out_of_range
      arrow.out_of_range = false
      return if arrow.head_dms == dms
      move_cost = 999
    end

    if map_sprite.move_count - move_cost < 0 
      if tile_route
        map_sprite.move_count = movement.value
        if tile_route == "#"
          arrow.clear
          return
        end
        arrow.build_arrow(tile_route: tile_route, center: movement.value, dms: dms)
        move_cost = tile_route[-1][-1]
      else
        return
      end
    else
      arrow.setup_arrow(move: move, dms: dms)
    end
    map_sprite.move_count -= move_cost
  end

  def clear_arrow
    map_sprite.arrow.clear
    map_sprite.move_count = 0
  end

  def change_highlighter_state(state:)
    map_sprite.highlighter_offset = movement.value
    map_sprite.highlighter_state = state
  end

  def add_moveable_tiles(moveable_tiles:)
    map_sprite.movable_tiles = moveable_tiles if !map_sprite.movable_tiles
  end
end