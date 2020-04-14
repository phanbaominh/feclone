require_rel '../modules/drawable'
require_rel '../modules/dimensionable'
class Cursor
  include Dimensionable
  include Drawable
  
  attr_reader :sprite, :buttons, :timeable, :wait, :animators, :ani_state, :map
  
    
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
  
  def debounced?
    !timeable.update_time?
  end
  private
  ######################
  #BUTTONABLE INTERFACE#
  ######################

  
  ####################
  #DRAWABLE INTERFACE#
  ####################
end