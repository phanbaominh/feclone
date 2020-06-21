# frozen_string_literal: true

require_relative 'timeable'
require_relative 'movable'
class Animator
  include Movable
  attr_reader :sprite, :times_per_frame, :timeable, :reverse, :dms
  attr_accessor :delta, :current_frame
  def initialize(sprite: nil, times_per_frame: nil, reverse: false, dms: nil)
    @dms = dms
    @sprite = sprite.each { |e| e.dms = @dms unless e.dms }
    @times_per_frame = times_per_frame
    @timeable = Timeable.new(wait: times_per_frame[0])
    @current_frame = 0
    @reverse = reverse
    @delta = 1
  end

  def current_frame_sprite
    if timeable.update_time?
      update_current
      timeable.wait = times_per_frame[current_frame]
    end
    sprite[current_frame]
  end

  def reset_frame
    self.current_frame = 0
    timeable.set_current
  end

  def draw
    current_frame_sprite.draw
  end

  def dms=(value)
    @dms = value
    @sprite.each { |e| e.dms = dms }
  end

  private

  def update_current
    if current_frame >= sprite.size - 1
      reverse ? self.delta = -1 : self.current_frame = -1
    end
    self.delta = 1 if current_frame.negative?
    self.current_frame += delta
  end
end
