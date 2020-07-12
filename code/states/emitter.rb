# typed: true
# frozen_string_literal: true

module Emitter
  extend T::Sig

  Payload = T.type_alias { T::Hash[Symbol, T.untyped] }
  Observers = T.type_alias { T.nilable(T::Hash[Symbol, Observer]) }
  EventQueue = T.let([], T::Array[Symbol])
  PayloadQueue = T.let([], T::Array[Payload])

  @finished = T.let(true, T::Boolean)
  class << self
    extend T::Sig
    sig { returns(T::Boolean) }
    attr_accessor :finished
  end

  sig { returns(Observers) }
  attr_reader :obs

  sig { params(ob: Observer).void }
  def add_ob(ob)
    @obs = T.let({}, Observers) unless obs
    T.must(obs)[ob.ob_name] = ob
  end

  sig { params(_obs: T::Array[Observer]).void }
  def add_obs(_obs)
    _obs.each { |ob| add_ob(ob) }
  end

  sig { params(ob: Observer).void }
  def remove_ob(ob)
    T.must(obs).delete(ob.ob_name)
  end

  sig { params(event: Symbol, payload: Payload).void }
  def emit(event, payload: {})
    EventQueue.unshift(event)
    PayloadQueue.unshift(payload)
    # p EventQueue
    # p PayloadQueue
    if Emitter.finished
      Emitter.finished = false
      until EventQueue.empty?

        _event = T.must(EventQueue.shift)
        _payload = T.must(PayloadQueue.shift)
        T.must(obs).each { |_, ob| ob.on_notify(_event, payload: _payload) }
      end
      Emitter.finished = true
    end
  end
end