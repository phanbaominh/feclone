# typed: true
# frozen_string_literal: true

class Timeable
  extend T::Sig

  sig { returns(Integer) }
  attr_accessor :last_time

  sig { returns(Integer) }
  attr_accessor :wait

  sig { params(last_time: Integer, wait: Integer).void }
  def initialize(last_time: Gosu.milliseconds, wait: 0)
    @last_time = last_time
    @wait = wait
  end

  sig { returns(T::Boolean) }
  def update_time?
    time_since_last > wait ? set_current : false
  end

  sig { returns(TrueClass) }
  def set_current
    self.last_time = Gosu.milliseconds
    true
  end

  sig { returns(Integer) }
  def time_since_last
    Gosu.milliseconds - last_time
  end
end
