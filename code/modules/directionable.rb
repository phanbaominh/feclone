# typed: true
# frozen_string_literal: true

class DirectionEnum < T::Enum
  extend T::Sig
  enums do
    Left = new
    Right = new
    Up = new
    Down = new
    None = new
  end

  sig { returns(Symbol) }
  def to_sym
    serialize.to_sym
  end
end
module Directionable
  GRID_VALUE = {
    left: -1,
    right: 1,
    up: -1,
    down: 1
  }.freeze
  HORIZONTAL = %i[left right].freeze
  VERTICAL = %i[up down].freeze

  class << self
    def opposite_direction?(last_move, move)
      same_axis?(last_move, move) && last_move != move
    end

    def direction!(tile_dms, prev_tile_dms, dms: nil)
      delta_x = tile_dms.x_grid - prev_tile_dms.x_grid
      delta_y = tile_dms.y_grid - prev_tile_dms.y_grid

      if dms
        dms.x_grid += delta_x
        dms.y_grid += delta_y
      end

      move = if delta_x != 0
               delta_x.positive? ? DirectionEnum::Right : DirectionEnum::Left
             else
               delta_y.positive? ? DirectionEnum::Down : DirectionEnum::Up
             end
      move
    end

    def dms_after_move(dms, move: nil, move_value: nil)
      delta_x = 0
      delta_y = 0
      move_value ||= GRID_VALUE[move.to_sym]
      delta_x = move_value if horizontal?(move)
      delta_y = move_value if vertical?(move)
      # p dms
      Dimensioner.new(
        {
          x_grid: dms.x_grid + delta_x,
          y_grid: dms.y_grid + delta_y,
          z: dms.z,
          x_offset: dms.x_offset,
          y_offset: dms.y_offset
        }
      )
    end

    def horizontal?(move)
      return unless move

      HORIZONTAL.include?(move.to_sym)
    end

    def vertical?(move)
      return unless move

      VERTICAL.include?(move.to_sym)
    end

    def same_axis?(last_move, move)
      (horizontal?(move) && horizontal?(last_move)) ||
        (vertical?(move) && vertical?(last_move))
    end
  end
end

