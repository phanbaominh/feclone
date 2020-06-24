# typed: true
# frozen_string_literal: true

class Timeable
  attr_accessor :last_time, :wait
  def initialize(last_time: Gosu.milliseconds, wait: 0)
    @last_time = last_time
    @wait = wait
  end

  def update_time?
    time_since_last > wait ? set_current : false
  end

  def set_current
    self.last_time = Gosu.milliseconds
  end

  def time_since_last
    Gosu.milliseconds - last_time
  end
end
