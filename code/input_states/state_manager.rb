# typed: true
# frozen_string_literal: true

class StateManager
  extend T::Sig
  include Observer

  sig { void }
  def initialize
    @map = T.let(Map.new(image_path: 'assets/map/test.png'), Map)
    @cursor = T.let(Cursor.new(map: map), Cursor)
    @arrow_drawer = T.let(ArrowDrawer.new, ArrowDrawer)
    @highlighter_drawer = T.let(HighlighterDrawer.new, HighlighterDrawer)
  end

  sig { params(input: Symbol).void }
  def feed(input)

  end

  private

  sig { params(state: T.class_of(InputState)).returns(InputState) }
  def create_input_state(state)
    input_state = state.new
    input_state.add_obs([@map, @cursor, @arrow_drawer, @highlighter_drawer])
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_unit_selected(payload = {})
    self.current_state = :selected
  end
end