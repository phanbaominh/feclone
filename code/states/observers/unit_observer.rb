# typed: true
# frozen_string_literal: true

class UnitObserver
  extend T::Sig
  include Observer
  include Emitter

  sig { returns(T.nilable(Unit)) }
  attr_reader :unit

  def initialize
    @obs = T.let({}, Emitter::Observers)
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_unit_selected(payload)
    @unit = T.let(payload.fetch(:unit), T.nilable(Unit))
  end

  sig { params(payload: Emitter::Payload).void }
  def on_selected_unselect_unit(payload = {})
    T.must(unit).change_sprite_state(state: :hover)
    emit(:selected_unit_unselected, payload: { unit: unit })
    @unit = nil
  end
end