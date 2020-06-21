class InputState
  include Buttonable
  attr_accessor :map, :cursor, :buttons, :next_state, :current_state, :arrow_drawer
  def initialize(map:, cursor:, arrow_drawer:)
    @map = map
    @cursor = cursor
    @arrow_drawer = arrow_drawer
    populate_buttons
    set_current_state
    change_cursor_state
  end

  def post_handling
    tmp = next_state
    self.next_state = current_state
    tmp
  end

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
