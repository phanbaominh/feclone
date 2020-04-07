require_rel 'drawable'
class Cursor
  include Buttonable
  include Drawable

  attr_reader :sprite, :x_grid, :y_grid, :buttons, :timeable, :wait, :animatable
  attr_writer :x_grid, :y_grid

  def initialize(x_grid: 0, y_grid: 0, z: GameConstants::Z_CURSOR, sprite: GameConstants::PLAYER_CURSOR_SPRITE, animatable: true)
    @x_grid = x_grid
    @y_grid = y_grid
    @timeable = Timeable.new(last_time: Gosu.milliseconds,
                             wait:      GameConstants::CURSOR_DELAY)
    @buttons = {KB_DOWN:  true,
                KB_UP:    true,
                KB_RIGHT: true,
                KB_LEFT:  true
                }
    @animatable = animatable ?
                    Animatable.new(sprite:          sprite,
                                   times_per_frame: [500, 50, 50, 50],
                                   reverse:         true) : nil
    @sprite = @sprite
  end

  ######################
  #BUTTONABLE INTERFACE#
  ######################

  def pre_handling
    timeable.update_time?
  end
  
  def kb_down
    self.y_grid += 1
  end

  def kb_up
    self.y_grid -= 1
  end

  def kb_right
    self.x_grid += 1
  end
  
  def kb_left
    self.x_grid -= 1
  end

  ######################
  #DRAWABLE INTERFACE#
  ######################

  def draw
    super(x: Util.get_real_pos(x_grid),
          y: Util.get_real_pos(y_grid),
          z: GameConstants::Z_CURSOR
    )
  end
end