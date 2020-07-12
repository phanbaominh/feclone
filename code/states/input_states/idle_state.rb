# typed: true
# frozen_string_literal: true

require_relative 'input_state'
class IdleState < InputState
  def pre_press(button)
    return unless (direction = movement_button?(button))
    emit(:idle_move_cursor, payload: { direction: direction })
  end

  def kb_z
    emit(:idle_select_unit)
  end
end
