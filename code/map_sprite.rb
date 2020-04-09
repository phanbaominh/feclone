class MapSprite
  include Drawable

  attr_accessor :sprite, :animators, :dimensioner
  attr_reader :ani_state
  
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
      setup_animators
    end
    #p have_states?
  end
  
  

  def ani_state=(value)
    @ani_state = value
    cur_animator.reset_frame
  end

  private
  
  def setup_animators
    @animators = {
      idle: build_animator(
        index: 5, 
        frames_count: 3, 
        times_per_frame: [500, 50, 500],
        delta: 5
      ),
      selected: build_animator(
        index: 9,
        frames_count: 3,
        times_per_frame: [500, 50, 500],
        delta: 5
      )
    }
    @ani_state = :idle
  end
  ####################
  #DRAWABLE INTERFACE#
  ####################
end