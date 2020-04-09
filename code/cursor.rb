require_rel 'drawable'
class Cursor
  include Buttonable
  include Drawable

  attr_reader :sprite, :buttons, :timeable, :wait, :animator
  attr_accessor :dimensioner
  
    
  def self.map_spr_dms(x: 0, y: 0)
    Dimensioner.new(
      x_grid: x,
      y_grid: y,
      z: GC::Z_CURSOR,
      x_offset: -8 * GC::SCALING_FACTOR,
      y_offset: -8 * GC::SCALING_FACTOR
    )
  end

  def initialize(
    dimensioner: Cursor.map_spr_dms,
    sprite: GC::PLAYER_CURSOR_SPRITE,
    animatable: true
  )
    @dimensioner = dimensioner
    @timeable = Timeable.new(last_time: Gosu.milliseconds,
                             wait: GC::CURSOR_DELAY)
    @buttons = {KB_DOWN:  true,
                KB_UP:    true,
                KB_RIGHT: true,
                KB_LEFT:  true}

    @animator = nil
    @animator = Animator.new(sprite: sprite,
                             times_per_frame: [500, 50, 50, 50],
                             reverse: true) if animatable
    @sprite = sprite
  end

  ######################
  #BUTTONABLE INTERFACE#
  ######################

  def pre_handling
    timeable.update_time?
  end
  
  def post_press
  end
  
  def kb_down
    dimensioner.y_grid += 1
  end

  def kb_up
    dimensioner.y_grid -= 1
  end

  def kb_right
    dimensioner.x_grid += 1
  end
  
  def kb_left
    dimensioner.x_grid -= 1
  end

  ####################
  #DRAWABLE INTERFACE#
  ####################
end