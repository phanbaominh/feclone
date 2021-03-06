# typed: true
# frozen_string_literal: true

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

  def placeholder_name
    'Name' + map_sprite.dms.x_grid.to_s + map_sprite.dms.y_grid.to_s
  end

  def inspect
    name || placeholder_name
  end

  def to_s
    name || placeholder_name
  end

  def dms
    map_sprite.dms
  end

  def change_ani_state(state: state)
    map_sprite.ani_state = state
  end

  def change_sprite_state(state:)
    change_ani_state(state: state)
  end

  def clear_arrow
    map_sprite.arrow.clear
    map_sprite.move_value = 0
  end

  def change_highlighter_state(state:)
    map_sprite.highlighter_offset = movement.value
    map_sprite.highlighter_state = state
  end

  def add_moveable_tiles(moveable_tiles:)
    map_sprite.movable_tiles = moveable_tiles unless map_sprite.movable_tiles
  end
end
