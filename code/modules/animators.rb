class Animators
  attr_accessor :ani_state, :animators
  
  def build_animator(sprite, state, frames_count, times_per_frame, index, delta, reverse: true)
    animator = Animator.new(
      sprite: build_sprite(sprite, frames_count, index, delta),
      times_per_frame: times_per_frame,
      reverse: reverse,
    )
    animators[state] = animator
  end


  def initialize(animators, ani_state)
    @animators = animators || {}
    @ani_state = ani_state
  end

  def draw
    cur_animator.draw
  end

  def ani_state=(value)
    @ani_state = value
    cur_animator.reset_frame
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

end