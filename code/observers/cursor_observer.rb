# typed: true
# frozen_string_literal: true

class CursorObserver
  extend T::Sig
  include Observer
  include Emitter

  private

  sig { returns(Cursor) }
  attr_reader :cursor

  sig { params(cursor: Cursor).void }
  def initialize(cursor)
    @cursor = cursor
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_move_cursor(payload)
    return if cursor.ani_stators.finished_moving? && !cursor.debounced?

    prev_dms = cursor.dms
    direction = T.let(payload.fetch(:direction), DirectionEnum)
    cursor.dms = Directionable.dms_after_move(cursor.dms, move: direction)
    cursor.ani_stators.move(direction, 6)
    emit(:idle_cursor_moved, payload: { cursor: cursor, prev_dms: prev_dms })
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
end