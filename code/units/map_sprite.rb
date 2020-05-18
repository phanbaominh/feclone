# frozen_string_literal: true

class MapSprite
  include AniStatable
  include Dimensionable
  attr_accessor :movable_tiles, :highlighter_state, :highlighter_offset, :move_value
  attr_reader :base_move_value, :sprite, :ani_stators, :arrow
  ANI_STATES = %i[left right down up idle wait hover].freeze
  def self.map_spr_dms(x: 0, y: 0)
    Dimensioner.new(
      x_grid: x,
      y_grid: y,
      z: GC::Z_UNIT,
      x_offset: -8 * GC::SCALING_FACTOR,
      y_offset: -16 * GC::SCALING_FACTOR
    )
  end

  def initialize(dimensioner: MapSprite.default_map_spr_dms,
                 move_value:,
                 image_path: nil,
                 animatable: true)
    @sprite = Sprite.load_tiles(image_path, 32, 32, retro: true)
    @dms = dimensioner
    setup_ani_stators

    @movable_tiles = nil
    @highlighter_state = :idle

    @arrow = Arrow.new
    @move_value = move_value
    @base_move_value = move_value
  end

  def draw
    ani_stators.draw

    if movable_tiles && highlighter_state != :idle
      movable_tiles.each_with_index do |row, i|
        row.each_with_index do |tile, j|
          if tile
            Highlighter.draw(const: highlighter_const_name, x_grid: x_grid + (j - highlighter_offset), y_grid: y_grid + (i - highlighter_offset))
          end
        end
      end
    end

    arrow.draw(dms)
  end

  def change_move_state(move, cursor_dms, move_cost)
    self.ani_state = move if ani_state != move && arrow.empty?

    tile_route = route_to_tile(cursor_dms)

    return if cursor_oor?(cursor_dms, tile_route)

    move_cost = -move_cost if arrow.opposite_direction?(arrow.last_move, move)

    if cursor_in_range_after_oor?
      arrow.out_of_range = false
      move_cost = 999
      return if cursor_back_to_origin_before_oor?(cursor_dms)
    end

    if out_of_move?(move_cost)
      return unless rebuild_arrow(tile_route, cursor_dms)
    else
      arrow.setup_arrow(move: move, dms: cursor_dms)
    end
    self.move_value -= move_cost
  end

  def dms=(value)
    @dms = value
    @ani_stators.dms.mutate(value)
  end

  private

  def rebuild_arrow(tile_route, cursor_dms)
    return false unless tile_route

    self.move_value = base_move_value
    if tile_route == :center
      arrow.clear
      return false
    end
    arrow.build_arrow(tile_route: tile_route, center: base_move_value, dms: cursor_dms)
    move_cost = tile_route[-1][-1]
  end

  def out_of_move?(move_cost)
    move_value - move_cost < 0
  end

  def cursor_in_range_after_oor?
    arrow.out_of_range
  end

  def cursor_back_to_origin_before_oor?(cursor_dms)
    arrow.head_dms == cursor_dms
  end

  def route_to_tile(cursor_dms)
    j = cursor_dms.y_grid + base_move_value - y_grid
    i = cursor_dms.x_grid + base_move_value - x_grid
    tile_route = movable_tiles[j][i]
  end

  def cursor_oor?(_cursor_dms, tile_route)
    if !tile_route
      arrow.out_of_range = true
      true
    else
      false
    end
  end

  def highlighter_const_name
    "#{highlighter_state.upcase}_BLUE_HIGHLIGHTER"
  end

  def setup_ani_stators
    @ani_stators = AniStators.new(ani_state: :idle, dms: dms)
    moving = true
    ANI_STATES.each_with_index do |state, i|
      if !moving || state == :idle
        build_animator(state, index: i * 4)
        moving = false
      else
        build_animator(state, index: i * 4, frames_count: 4, times_per_frame: [150] * 4)
      end
    end
    animators[:active] = animators[:down]
    self.ani_state = :idle
  end

  def build_animator(state, index: 4, frames_count: 3, times_per_frame: [500, 50, 500])
    ani_stators.build_animator(
      sprite: sprite,
      state: state,
      index: index,
      frames_count: frames_count,
      times_per_frame: times_per_frame
    )
  end
end
