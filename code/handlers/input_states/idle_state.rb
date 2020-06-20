require_relative 'input_state'
class IdleState < InputState
  def pre_handling
    cursor.ani_stators.finished_moving? && !cursor.debounced?
  end

  def pre_press(button)
    change_cursor_state(move_out: true) if movement_button?(button)
  end

  def post_press(button)
    if direction = movement_button?(button)
      change_cursor_state
      cursor.ani_stators.move(direction, 4)
    end
  end

  def change_cursor_state(move_out: false)
    unit = unit_focused?
    if unit && move_out
      unit.change_sprite_state(state: :idle)
      cursor.ani_state = :idle
    elsif unit && cursor.ani_state == :idle
      unit.add_moveable_tiles(moveable_tiles: PathFinder.perform(map.terrains, unit.dms, unit.movement))
      cursor.ani_state = :hover
      unit.change_sprite_state(state: :hover)
    elsif !unit && cursor.ani_state == :hover
      cursor.ani_state = :idle
    end
  end

  def kb_down
    cursor.y_grid += Cursor::CURSOR_MOVE_VALUE
  end

  def kb_up
    cursor.y_grid -= Cursor::CURSOR_MOVE_VALUE
  end

  def kb_right
    cursor.x_grid += Cursor::CURSOR_MOVE_VALUE
  end

  def kb_left
    cursor.x_grid -= Cursor::CURSOR_MOVE_VALUE
  end

  def kb_z
    if (unit = unit_focused?)
      self.next_state = :selected
      unit.change_sprite_state(state: :active)
    end
  end

  private

  def set_current_state
    self.current_state = :idle
    self.next_state = :idle
  end

  def unit_focused?
    map.unit_present?(cursor.x_grid, cursor.y_grid)
  end
end
