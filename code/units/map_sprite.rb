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
                 image_path: nil,
                 animatable: true)
    @sprite = Tiler.perform(image_path, false, 32, 32)
    draw_wait_sprite
    @dimensioner = dimensioner
    if animatable
      setup_animators
    end
    #p have_states?
  end
  
  private
  
  def setup_animators
    @animators = {
      idle: build_animator(
        index: 5, 
        frames_count: 3, 
        times_per_frame: [500, 50, 500],
        delta: 5,
        rmagick: true
      ),
      selected: build_animator(
        index: 9,
        frames_count: 3,
        times_per_frame: [500, 50, 500],
        delta: 5,
        rmagick: true
      ),
      wait: build_animator(
        index: 20,
        frames_count: 3,
        times_per_frame: [500, 50, 500],
        delta: 1,
        rmagick: true
      )
    }
    @ani_state = :wait
  end

  def draw_wait_sprite
    3.times do |i|
      self.sprite << sprite[(i+1)*5].quantize(256, Magick::GRAYColorspace)
    end
  end
  ####################
  #DRAWABLE INTERFACE#
  ####################
end