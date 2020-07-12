# typed: true
# frozen_string_literal: true

class SelectedState < InputState
  def pre_press(button)
    return unless (direction = movement_button?(button))
    emit(:selected_move_cursor, payload: { direction: direction })
  end

  def kb_z; end

  def kb_x
    emit(:selected_unselect_unit)
  end
end
