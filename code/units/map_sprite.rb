# frozen_string_literal: true

class MapSprite
  include AniStatable
  include Dimensionable
  attr_accessor :movable_tiles, :highlighter_state, :highlighter_offset, :move_value
  attr_reader :base_move_value, :sprite, :ani_stators, :arrow
  ANI_STATES = %i[left right down up idle wait hover].freeze
  def self.map_spr_dms(x: 0, y: 0)
    Dimensioner.new(
      x_grid: x,
      y_grid: y,
      z: GC::Z_UNIT,
      x_offset: -8 * GC::SCALING_FACTOR,
      y_offset: -16 * GC::SCALING_FACTOR
    )
  end

  def initialize(dimensioner:,
                 image_path:,
                 animatable: true)
    @sprite = Sprite.load_tiles(image_path, 32, 32, retro: true)
    @dms = dimensioner
    setup_ani_stators
    @movable_tiles = nil
    @highlighter_state = :idle
  end

  def draw
    ani_stators.draw
  end

  def dms=(value)
    @dms = value
    @ani_stators.dms.mutate(value)
  end

  private

  def setup_ani_stators
    @ani_stators = AniStators.new(ani_state: :idle, dms: dms)
    moving = true
    ANI_STATES.each_with_index do |state, i|
      if !moving || state == :idle
        build_animator(state, index: i * 4)
        moving = false
      else
        build_animator(state, index: i * 4, frames_count: 4, times_per_frame: [150] * 4)
      end
    end
    animators[:active] = animators[:down]
    self.ani_state = :idle
  end

  def build_animator(state, index: 4, frames_count: 3, times_per_frame: [500, 50, 500])
    ani_stators.build_animator(
      sprite: sprite,
      state: state,
      index: index,
      frames_count: frames_count,
      times_per_frame: times_per_frame
    )
  end
end
