# typed: true
# frozen_string_literal: true

module Emitter
  extend T::Sig

  sig { returns(T::Hash[Symbol, Observer]) }
  attr_reader :obs

  Payload = T.type_alias { T::Hash[Symbol, T.untyped] }

  sig { params(ob: Observer).void }
  def add_ob(ob)
    obs[ob.ob_name] = ob
  end

  sig { params(_obs: T::Array[Observer]).void }
  def add_obs(_obs)
    _obs.each { |ob| add_ob(ob) }
  end

  sig { params(ob: Observer).void }
  def remove_ob(ob)
    obs.delete(ob.ob_name)
  end

  sig { params(event: Symbol, payload: Payload).void }
  def emit(event, payload: {})
    obs.each { |_, ob| ob.on_notify(event, payload: payload) }
  end
end