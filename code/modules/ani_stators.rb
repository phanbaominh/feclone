# typed: true
# frozen_string_literal: true

require_relative 'movable'
class AniStators
  extend T::Sig
  include Movable
  attr_accessor :animators
  attr_reader :ani_state

  def build_animator(sprite:, state:, **options)
    options = default_options.merge(options)
    animator = Animator.new(
      sprite: build_sprite(
        sprite, options[:frames_count], options[:index], options[:delta]
      ),
      times_per_frame: options[:times_per_frame],
      reverse: options[:reverse],
      dms: options[:personal_dms] || dms
    )
    animators[state] = animator
  end

  def initialize(animators: {}, ani_state:, dms: nil)
    @animators = animators
    @ani_state = ani_state
    @dms = dms.dup
  end

  def draw
    cur_animator.draw
  end

  def ani_state=(value)
    @ani_state = value
    cur_animator.reset_frame
  end

  def dms=(value)
    @dms = value
    animators.values.each { |animator| animator.dms = value }
  end

  def set_move(direction, speed)
    self.move_object = Move.new(direction, speed, 1)
    animators.values.each do |animator|
      animator.move_object = move_object
    end
  end

  sig { returns(T::Boolean) }
  def finished_moving?
    cur_animator.finished_moving?
  end

  private

  def cur_animator
    animators[ani_state]
  end

  def build_sprite(sprite, frames_count, index, delta)
    result = []
    frames_count.times do
      result << sprite[index]
      index += delta
    end
    result
  end

  def default_options
    {
      personal_dms: nil,
      frames_count: 1,
      times_per_frame: [0],
      index: 0,
      delta: 1,
      reverse: true
    }
  end
end
