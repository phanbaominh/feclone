class Animator
  attr_reader :sprite, :times_per_frame, :timeable, :reverse
  attr_accessor :delta, :current_frame

  def initialize(sprite: nil, times_per_frame: nil, reverse: false)
    @sprite = sprite
    @times_per_frame = times_per_frame
    @timeable = Timeable.new(wait: times_per_frame[0])
    @current_frame = 0
    @delta = 1
  end

  def get_frame
    if timeable.update_time?
        update_current
        self.timeable.wait = times_per_frame[current_frame]
    end
    sprite[current_frame]
  end
  
  private
  
  def update_current
    if current_frame >= sprite.size - 1
        reverse ? self.delta = -1 : self.current_frame = -1
    end
    self.delta = 1 if current_frame < 0
    self.current_frame += self.delta
 end
end