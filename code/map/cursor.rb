# typed: true
# frozen_string_literal: true

require_rel '../modules/dimensionable'
require_rel '../modules/ani_statable'
class Cursor
  include AniStatable
  include Dimensionable

  PLAYER_CURSOR_SPRITE =
    Sprite.load_tiles('assets/map_ui/cursor.png', 32, 32, retro: true)
  CURSOR_DELAY = 100
  CURSOR_MOVE_VALUE = 1
  attr_reader :sprite, :buttons, :timeable, :wait, :ani_stators, :map
  attr_accessor :step, :sign, :direction

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
    sprite: PLAYER_CURSOR_SPRITE,
    map: nil
  )
    @map = map
    @dms = dimensioner
    @timeable = Timeable.new(last_time: Gosu.milliseconds,
                             wait: CURSOR_DELAY)
    @sprite = sprite
    @step = 1
    @direction = nil
    @sign = 1
    setup_ani_stators
  end

  def debounced?
    !timeable.update_time?
  end

  def move(direction, sign)
    self.direction = direction
    self.sign = sign
  end

  def draw
    ani_stators.draw
  end

  private

  def setup_ani_stators
    @ani_stators = AniStators.new(ani_state: :idle, dms: dms)
    @ani_stators.build_animator(
      sprite: PLAYER_CURSOR_SPRITE,
      state: :idle,
      index: 0,
      frames_count: 4,
      times_per_frame: [300, 50, 50, 50]
    )
    @ani_stators.build_animator(
      sprite: PLAYER_CURSOR_SPRITE,
      state: :hover,
      index: 8,
      reverse: false
    )
  end
  ######################
  # BUTTONABLE INTERFACE#
  ######################

  ####################
  # DRAWABLE INTERFACE#
  ####################
end
