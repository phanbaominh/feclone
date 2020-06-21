class SelectedState < InputState
  attr_accessor :current_unit
  def pre_handling
    self.current_unit = unit_focused? unless current_unit
    cursor.ani_stators.finished_moving? && !cursor.debounced?
  end

  def pre_press(button)
    change_cursor_state(move_out: true) if movement_button?(button)
  end

  def post_press(button)
    if (direction = movement_button?(button))
      change_cursor_state
      cursor.ani_stators.move(direction, 4)
      change_move_state(move: direction)
    end
  end

  def change_cursor_state(move_out: false)
    cursor.ani_state = :idle
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

  def kb_z; end

  def kb_x
    rehover_cursor
    deactivate_unit
  end

  private

  def change_move_state(move:)
    arrow_drawer.change_move_state(
      move: move,
      cursor: cursor,
      cursor_terrain: Terrain.get_terrain(name: map.terrains[cursor.y_grid][cursor.x_grid])
    )
  end

  def set_current_state
    self.current_state = :selected
    self.next_state = :selected
  end

  def rehover_cursor
    cursor.x_grid = current_unit.x_grid
    cursor.y_grid = current_unit.y_grid
    cursor.rebind_dms
    cursor.ani_state = :hover
  end

  def deactivate_unit
    change_unit_sprite_state(current_unit, :hover)
    arrow_drawer.arrow.clear
    self.next_state = :idle
    self.current_unit = nil
  end

  def unit_focused?
    map.unit_present?(cursor.x_grid, cursor.y_grid)
  end
end
