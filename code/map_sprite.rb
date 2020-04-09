class MapSprite
  include Drawable

  attr_accessor :sprite, :animator, :dimensioner
  
  def self.map_spr_dms(x: 0, y: 0)
    Dimensioner.new(
      x_grid: x,
      y_grid: y,
      z: GC::Z_UNIT,
      x_offset: -8 * GC::SCALING_FACTOR,
      y_offset: -16 * GC::SCALING_FACTOR
    )
  end

  def initialize(dimensioner: MapSprite.default_map_spr_dms, 
                 sprite: nil,
                 animatable: true)
    @sprite = sprite
    @dimensioner = dimensioner
    if animatable
      @animators = {idle: build_animator(5, 3, [500, 50, 500]),
                    selected: build_animator(9, 3, [500, 50, 500])}
      @animator  = @animators[:selected]
      @state       = :idle
    end
  end

  private

  def build_sprite(index, frames_count)
    result = []
    frames_count.times do
        result << sprite[index]
        index += 5
    end
    result
  end

  def build_animator(index, frames_count, times_per_frame)
    Animator.new(sprite: build_sprite(index, frames_count),
                   times_per_frame: times_per_frame,
                   reverse: true)
  end
  
  ####################
  #DRAWABLE INTERFACE#
  ####################
end