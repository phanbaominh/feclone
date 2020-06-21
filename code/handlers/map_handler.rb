# frozen_string_literal: true

class MapHandler
  # include Buttonable
  attr_accessor :map, :cursor, :buttons, :unit_activated, :current_unit, :input_state, :input_states
  attr_reader :arrow_drawer, :highlighter_drawer
  def initialize(map: nil, cursor: nil)
    @map = map
    @cursor = cursor
    @arrow_drawer = ArrowDrawer.new
    @highlighter_drawer = HighlighterDrawer.new
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
      idle: new_input_state(IdleState),
      selected: new_input_state(SelectedState)
    }
  end

  def draw
    cursor.draw
    map.draw
    arrow_drawer.draw
    highlighter_drawer.draw
  end

  def handle_buttons
    self.input_state = input_states[input_state].handle_buttons
  end

  private

  def new_input_state(state)
    state.new(
      map: map,
      cursor: cursor,
      arrow_drawer: arrow_drawer,
      highlighter_drawer: highlighter_drawer
    )
  end
  ######################
  # BUTTONABLE INTERFACE#
  ######################
end
