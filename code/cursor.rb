require_rel 'drawable'
class Cursor
  include Buttonable
  include Drawable

  attr_reader :sprite, :buttons, :timeable, :wait, :animators, :ani_state, :map
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
    map: nil
  )
    @map = map
    @dimensioner = dimensioner
    @timeable = Timeable.new(last_time: Gosu.milliseconds,
                             wait: GC::CURSOR_DELAY)
    @buttons = {KB_DOWN:  true,
                KB_UP:    true,
                KB_RIGHT: true,
                KB_LEFT:  true}
    @sprite = sprite

    @animators = {
      idle: build_animator(
        index: 0,
        frames_count: 4,
        times_per_frame: [300, 50, 50, 50],
      ),
      selected: build_animator(
        index: 8,
        reverse: false
      )
    }

    @ani_state = :selected
  end
  
  private
  ######################
  #BUTTONABLE INTERFACE#
  ######################

  def pre_handling
    timeable.update_time?
  end
  
  def pre_press(button)
    if movement_button?(button)
      change_state(move_out: true)
    end
  end

  def post_press(button)
    if movement_button?(button)
      change_state
    end
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
  
  def change_state(move_out: false)
    unit = unit_focused?
    if unit && move_out
      unit.map_sprite.ani_state = :idle
      self.ani_state = :idle
    elsif unit && ani_state == :idle
      self.ani_state = :selected
      unit.map_sprite.ani_state = :selected
    elsif !unit && ani_state == :selected
      self.ani_state = :idle
    end
  end

  def unit_focused?
    map.unit_present?(dimensioner.x_grid, dimensioner.y_grid)
  end
  ####################
  #DRAWABLE INTERFACE#
  ####################
  def rmagick?
    true
  end
end