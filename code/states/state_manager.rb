# typed: true
# frozen_string_literal: true

require_rel '../../code'
class StateManager
  extend T::Sig
  include Observer

  MAP = T.let(Map.new(image_path: 'assets/map/test.png'), Map)
  CURSOR = T.let(Cursor.new(map: Map), Cursor)
  ARROW_DRAWER = T.let(ArrowDrawer.new, ArrowDrawer)
  HIGHLIGHTER_DRAWER = T.let(HighlighterDrawer.new, HighlighterDrawer)


  sig { void }
  def self.draw
    MAP.draw
    CURSOR.draw
    ARROW_DRAWER.draw
    HIGHLIGHTER_DRAWER.draw
  end

  sig { params(current_state: InputState).returns(InputState) }
  attr_writer :current_state

  sig { void }
  def initialize
    @map_ob = T.let(MapObserver.new(StateManager::MAP), MapObserver)
    @cursor_ob = T.let(CursorObserver.new(StateManager::CURSOR), CursorObserver)
    @arrow_ob = T.let(ArrowObserver.new(StateManager::ARROW_DRAWER), ArrowObserver)
    @highlighter_ob = T.let(
      HighlighterObserver.new(StateManager::HIGHLIGHTER_DRAWER),
      HighlighterObserver
    )
    @unit_ob = T.let(UnitObserver.new, UnitObserver)
    @obs = T.let(
        [@map_ob, @cursor_ob, @arrow_ob, @highlighter_ob, @unit_ob, self],
        T::Array[Observer]
    )
    setup_ob
    @input_states = T.let(
      {
        idle: create_input_state(IdleState),
        selected: create_input_state(SelectedState)
      },
      T::Hash[Symbol, InputState]
    )
    @current_state = T.let(@input_states.fetch(:idle), InputState)
    @current_state.emit(:idle_move_cursor, payload: { direction: DirectionEnum::None })
  end

  sig { void }
  def handle_buttons
    @current_state.handle_buttons
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_unit_selected(payload = {})
    self.current_state = @input_states.fetch(:selected)
  end

  sig { params(payload: Emitter::Payload).void }
  def on_selected_unit_unselected(payload = {})
    self.current_state = @input_states.fetch(:idle)
  end

  private

  sig { void }
  def setup_ob
    @map_ob.add_obs(@obs)
    @cursor_ob.add_obs(@obs)
    @unit_ob.add_obs(@obs)
  end

  sig { params(state: T.class_of(InputState)).returns(InputState) }
  def create_input_state(state)
    input_state = state.new
    input_state.add_obs(@obs)
    input_state
  end
end