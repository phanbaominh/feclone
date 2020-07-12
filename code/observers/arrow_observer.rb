# typed: true
# frozen_string_literal: true

class ArrowObserver
  extend T::Sig
  include Observer

  sig { returns(ArrowDrawer) }
  attr_reader :arrow_drawer
  sig { params(arrow_drawer: ArrowDrawer).void }
  def initialize(arrow_drawer)
    @arrow_drawer = arrow_drawer
  end

  sig { params(payload: Emitter::Payload).void }
  def on_unit_selected(payload)
    unit = T.let(payload.fetch(:unit), Unit)
    arrow_drawer.bind_unit(unit: unit)
  end
end