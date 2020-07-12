# typed: true
# frozen_string_literal: true

class HighlighterObserver
  extend T::Sig
  include Observer

  sig { returns(HighlighterDrawer) }
  attr_reader :highlighter_drawer
  sig { params(highlighter_drawer: HighlighterDrawer).void }
  def initialize(highlighter_drawer)
    @highlighter_drawer = highlighter_drawer
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_unit_hovered(payload)
    unit = T.let(payload.fetch(:unit), Unit)
    highlighter_drawer.bind_unit(unit: unit)
    highlighter_drawer.state = :hover
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_unit_unhovered(payload = {})
    highlighter_drawer.state = :idle
  end

  sig { params(payload: Emitter::Payload).void }
  def on_idle_unit_selected(payload = {})
    highlighter_drawer.state = :active
  end

  sig { params(payload: Emitter::Payload).void }
  def on_selected_unselect_unit(payload = {})
    highlighter_drawer.state = :hover
  end
end