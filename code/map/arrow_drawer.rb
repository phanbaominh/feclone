# frozen_string_literal: true

class ArrowDrawer
  attr_accessor :arrow, :movement, :move_value, :map_sprite
  def initialize
    @arrow = Arrow.new
  end

  def draw
    return unless map_sprite

    arrow.draw(map_sprite.dms)
  end

  def change_move_state(move:, cursor:, cursor_terrain:)
    cursor_dms = cursor.dms.dup
    move_cost = cursor_terrain.move_cost(movement.type)

    map_sprite.ani_state = move if map_sprite.ani_state != move && arrow.empty?

    tile_route = route_to_tile(cursor_dms)

    return if cursor_oor?(cursor_dms, tile_route)

    move_cost = -move_cost if arrow.opposite_direction?(arrow.last_move, move)

    if cursor_in_range_after_oor?
      arrow.out_of_range = false
      move_cost = 999
      return if cursor_back_to_origin_before_oor?(cursor_dms)
    end

    if out_of_move?(move_cost)
      rebuild_arrow(tile_route, cursor_dms)
      return
    else
      arrow.setup_arrow(move: move, dms: cursor_dms)
    end
    self.move_value -= move_cost
  end

  def bind_unit(
      unit:
  )
    arrow.clear
    @map_sprite = unit.map_sprite
    @move_value = unit.movement.value
    @movement = unit.movement
  end

  private

  def rebuild_arrow(tile_route, cursor_dms)
    return false unless tile_route

    if tile_route == :center
      arrow.clear
      return false
    end
    arrow.build_arrow(
      tile_route: tile_route,
      center: movement.value,
      dms: cursor_dms
    )
    self.move_value = movement.value - tile_route[-1][-1]
  end

  def out_of_move?(move_cost)
    (move_value - move_cost).negative?
  end

  def cursor_in_range_after_oor?
    arrow.out_of_range
  end

  def cursor_back_to_origin_before_oor?(cursor_dms)
    arrow.head_dms == cursor_dms
  end

  def route_to_tile(cursor_dms)
    j = cursor_dms.y_grid + movement.value - map_sprite.y_grid
    i = cursor_dms.x_grid + movement.value - map_sprite.x_grid
    map_sprite.movable_tiles[j][i]
  end

  def cursor_oor?(_cursor_dms, tile_route)
    if !tile_route
      arrow.out_of_range = true
      true
    else
      false
    end
  end
end