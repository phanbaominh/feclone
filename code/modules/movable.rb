# typed: true
# frozen_string_literal: true

module Movable
  MOVE_VALUE = 1.0
  Move = Struct.new(:direction, :speed, :step)
  attr_accessor :move_object, :dms

  def move(direction, speed)
    self.move_object = Move.new(direction, speed, 1)
  end

  def finished_moving?
    return true if !move_object || !move_object.direction

    value = MOVE_VALUE / move_object.speed * move_object.step

    increase_step(value)

    if value.to_i == MOVE_VALUE
      reset_move_object
      true
    else
      false
    end
  end

  private

  def increase_step(value)
    return unless value < MOVE_VALUE

    move_value = 1.0 * Directionable::GRID_VALUE[move_object.direction.to_sym] / move_object.speed
    self.dms = Directionable.dms_after_move(
      dms, move: move_object.direction, move_value: move_value
    )
    move_object.step += 1
  end

  def reset_move_object
    dms.x_grid = dms.x_grid.round
    dms.y_grid = dms.y_grid.round
    move_object.direction = nil
    move_object.step = 1
  end
end
