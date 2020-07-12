# typed: true
# frozen_string_literal: true

module Observer
  extend T::Sig
  extend T::Helpers

  include Kernel
  abstract!

  sig { params(event: Symbol, payload: Emitter::Payload).void }
  def on_notify(event, payload: {})
    send("on_#{event}", payload)
  end

  sig { returns(Symbol) }
  def ob_name
    object_id.to_s.to_sym
  end
end