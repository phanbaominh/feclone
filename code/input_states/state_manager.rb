# typed: true
# frozen_string_literal: true

require_rel '../../code'
class StateManager
  extend T::Sig
  include Observer

  Map = T.let(Map.new(image_path: 'assets/map/test.png'), Map)
  Cursor = T.let(Cursor.new(map: Map), Cursor)
  ArrowDrawer = T.let(ArrowDrawer.new, ArrowDrawer)
  HighlighterDrawer = T.let(HighlighterDrawer.new, HighlighterDrawer)


  sig { void }
  def self.draw
    Map.draw
    Cursor.draw
    ArrowDrawer.draw
    HighlighterDrawer.draw
  end

  sig { params(current_state: InputState1).returns(InputState1) }
  attr_writer :current_state

  sig { void }
  def initialize
    @obs = T.let({}, Emitter::Observers)
    @map_ob = T.let(MapObserver.new(StateManager::Map), MapObserver)
    @cursor_ob = T.let(CursorObserver.new(StateManager::Cursor), CursorObserver)
    @arrow_ob = T.let(ArrowObserver.new(StateManager::ArrowDrawer), ArrowObserver)
    @highlighter_ob = T.let(
      HighlighterObserver.new(StateManager::HighlighterDrawer),
      HighlighterObserver
    )
    @unit_ob = T.let(UnitObserver.new, UnitObserver)
    setup_ob
    @input_states = T.let(
      {
        idle: create_input_state(IdleState1),
        selected: create_input_state(SelectedState1)
      },
      T::Hash[Symbol, InputState1]
    )
    @current_state = T.let(@input_states[:idle], InputState1)
    @current_state.emit(:idle_move_cursor, payload: { direction: DirectionEnum::None })
  end

  sig { void }
  def handle_buttons
    return unless StateManager::Cursor.ani_stators.finished_moving? && !StateManager::Cursor.debounced?
    @current_state.handle_buttons
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_unit_selected(payload = {})
    self.current_state = @input_states[:selected]
  end

  sig { params(payload: Emitter::Payload).void }
  def on_selected_unit_unselected(payload = {})
    self.current_state = @input_states[:idle]
  end

  private

  sig { void }
  def setup_ob
    @obs = T.let(
      [@map_ob, @cursor_ob, @arrow_ob, @highlighter_ob, @unit_ob, self],
      T::Array[Observer]
    )
    @map_ob.add_obs(@obs)
    @cursor_ob.add_obs(@obs)
    @unit_ob.add_obs(@obs)
  end

  sig { params(state: T.class_of(InputState1)).returns(InputState1) }
  def create_input_state(state)
    input_state = state.new
    input_state.add_obs(@obs)
    input_state
  end
end