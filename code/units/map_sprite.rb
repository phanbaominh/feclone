class MapSprite
  include Drawable

  attr_accessor :sprite, :animators, :dimensioner
  attr_reader :ani_state
  ANI_STATES = [:left, :right, :down, :up, :idle, :wait, :selected]
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
                 image_path: nil,
                 animatable: true)
    @sprite = Gosu::Image.load_tiles(image_path, 32, 32, retro: true)
    @dimensioner = dimensioner
    if animatable
      setup_animators
    end
    #p have_states?
  end
  
  private
  
  def setup_animators
    @animators = {}
    moving = true
    ANI_STATES.each_with_index do |state, i|
      if !moving || state == :idle
        @animators[state] = standing_animator(index: i * 4)
        moving = false
      else
        @animators[state] = moving_animator(index: i * 4)
      end
    end
    @ani_state = :idle
  end
  
  def moving_animator(index: 0, frames_count: 4, times_per_frame: [150] * 4)
    build_animator(index: index, frames_count: frames_count, times_per_frame: times_per_frame)
  end

  def standing_animator(index: 4, frames_count: 3, times_per_frame: [500, 50, 500])
    build_animator(index: index, frames_count: frames_count, times_per_frame: times_per_frame)
  end
  ####################
  #DRAWABLE INTERFACE#
  ####################
end