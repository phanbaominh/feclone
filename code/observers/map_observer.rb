# typed: true
# frozen_string_literal: true

class MapObserver
  extend T::Sig
  include Observer
  include Emitter

  private

  sig { returns(Map) }
  attr_reader :map

  sig { params(map: Map).void }
  def initialize(map)
    @map = map
  end

  sig { params(unit: Unit).void }
  def hover_unit(unit)
    unit.add_moveable_tiles(
        moveable_tiles: PathFinder.new(
            map.terrains, unit.dms, unit.movement
        ).perform
    )
    emit(:idle_unit_hovered, payload: {unit: unit})
  end

  sig { params(payload: Emitter::Payload).void }
  def unhover_unit(payload)
    prev_dms = T.let(payload.fetch(:prev_dms), Dimensioner)
    unit = map.unit_present?(prev_dms.x_grid, prev_dms.y_grid)
    unit.change_sprite_state(state: :hover)
    emit(:idle_unit_unhovered)
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_cursor_moved(payload)
    cursor = T.let(payload.fetch(:cursor), Cursor)
    unit = map.unit_present?(cursor.x_grid, cursor.y_grid)
    if unit && cursor.ani_state == :idle
      hover_unit(unit)
    elsif !unit && cursor.ani_state == :hover
      unhover_unit(payload)
    end
  end

  def on_idle_select_unit(payload)
    cursor = T.let(payload.fetch(:cursor), Cursor)
    unit = map.unit_present?(cursor.x_grid, cursor.y_grid)
    return unless unit

    unit.change_sprite_state(state: :active)
    emit(:idle_unit_selected, payload: { unit: unit })
  end
end