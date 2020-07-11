# typed: true
# frozen_string_literal: true

class InputState
  include Buttonable
  attr_accessor :map, :cursor,
                :next_state, :current_state, :arrow_drawer
  attr_reader :highlighter_drawer
  def initialize(map:, cursor:, arrow_drawer:, highlighter_drawer:)
    @map = map
    @cursor = cursor
    @arrow_drawer = arrow_drawer
    @highlighter_drawer = highlighter_drawer
    populate_buttons
    set_current_state
    change_cursor_state
  end

  def post_handling
    tmp = next_state
    self.next_state = current_state
    tmp
  end

  protected

  def change_unit_sprite_state(unit, state)
    unit.change_sprite_state(state: state)
    highlighter_drawer.state = state
  end

  def set_current_state; end
  def change_cursor_state; end
  private

  def populate_buttons
    self.buttons = {
      KB_DOWN: true,
      KB_UP: true,
      KB_RIGHT: true,
      KB_LEFT: true,
      KB_Z: true,
      KB_X: true
    }
  end
end
