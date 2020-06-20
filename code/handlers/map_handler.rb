# frozen_string_literal: true

class MapHandler
  # include Buttonable
  attr_accessor :map, :cursor, :buttons, :unit_activated, :current_unit, :input_state, :input_states
  def initialize(map: nil, cursor: nil)
    @map = map
    @cursor = cursor
    @buttons = {
      KB_DOWN: true,
      KB_UP: true,
      KB_RIGHT: true,
      KB_LEFT: true,
      KB_Z: true,
      KB_X: true
    }
    @input_state = :idle
    @input_states = {
      idle: IdleState.new(map: map, cursor: cursor),
      selected: SelectedState.new(map: map, cursor: cursor)
    }
  end

  def draw
    cursor.draw
    map.draw
  end

  def handle_buttons
    self.input_state = input_states[input_state].handle_buttons
  end

  ######################
  # BUTTONABLE INTERFACE#
  ######################
end
