# typed: true
# frozen_string_literal: true

class InputState1
  include Buttonable1
  include Emitter
  def initialize
    populate_buttons
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
