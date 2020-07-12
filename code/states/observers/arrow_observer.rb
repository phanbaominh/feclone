# typed: true
# frozen_string_literal: true

class ArrowObserver
  extend T::Sig
  include Observer

  sig { returns(ArrowDrawer) }
  attr_reader :arrow_drawer
  sig { params(arrow_drawer: ArrowDrawer).void }
  def initialize(arrow_drawer)
    @arrow_drawer = arrow_drawer
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_unit_selected(payload)
    unit = T.let(payload.fetch(:unit), Unit)
    arrow_drawer.bind_unit(unit: unit)
  end

  sig { params(payload: Emitter::Payload).void }
  def on_selected_cursor_moved(payload)
    arrow_drawer.change_move_state(
      move: payload.fetch(:direction),
      cursor: StateManager::CURSOR,
      cursor_terrain: Terrain.get_terrain(
        name: StateManager::MAP.terrains[StateManager::CURSOR.y_grid][StateManager::CURSOR.x_grid]
      )
    )
  end

  sig { params(payload: Emitter::Payload).void }
  def on_selected_unselect_unit(payload = {})
    arrow_drawer.arrow.clear
  end
end