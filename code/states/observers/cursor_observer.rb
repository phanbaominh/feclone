# typed: true
# frozen_string_literal: true

class CursorObserver
  extend T::Sig
  include Observer
  include Emitter

  sig { returns(Cursor) }
  attr_reader :cursor

  sig { params(cursor: Cursor).void }
  def initialize(cursor)
    @cursor = cursor
    @obs = T.let({}, Emitter::Observers)
  end


  sig { params(payload: Emitter::Payload).void }
  def on_idle_move_cursor(payload)
    move_cursor(payload, :idle_cursor_moved)
  end

  sig { params(payload: Emitter::Payload, event: Symbol).void }
  def move_cursor(payload, event)
    direction = T.let(payload.fetch(:direction), DirectionEnum)
    return unless StateManager::CURSOR.responsive? || direction == DirectionEnum::None

    prev_dms = cursor.dms.clone
    if direction != DirectionEnum::None
      cursor.dms = Directionable.dms_after_move(cursor.dms, move: direction)
      cursor.ani_stators.set_move(direction, 6)
    end
    # p prev_dms
    # p cursor.dms
    emit(event, payload: { prev_dms: prev_dms, direction: direction })
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_unit_hovered(payload = {})
    cursor.ani_state = :hover
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_unit_unhovered(payload = {})
    cursor.ani_state = :idle
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_try_select_unit(payload = {})
    emit(:idle_select_unit, payload: { cursor: cursor })
  end

  sig { params(payload: Emitter::Payload).void }
  def on_selected_move_cursor(payload)
    move_cursor(payload, :selected_cursor_moved)
    cursor.ani_state = :idle
  end

  sig { params(payload: Emitter::Payload).void }
  def on_selected_unit_unselected(payload)
    current_unit = T.let(payload.fetch(:unit), Unit)
    cursor.x_grid = current_unit.x_grid
    cursor.y_grid = current_unit.y_grid
    cursor.rebind_dms
    cursor.ani_state = :hover
  end
end