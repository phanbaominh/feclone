# typed: true
# frozen_string_literal: true

module Movable
  extend T::Sig
  MOVE_VALUE = 1.0
  Move = Struct.new(:direction, :speed, :step)

  sig { returns(T.nilable(Move)) }
  attr_accessor :move_object

  sig { returns(Dimensioner) }
  attr_accessor :dms

  sig { returns(T::Boolean) }
  attr_accessor :move_finished

  sig { params(direction: DirectionEnum, speed: Integer).void }
  def set_move(direction, speed)
    self.move_object = Move.new(direction, speed, 1)
  end

  sig { void }
  def move
    _move_object = T.let(move_object, T.nilable(Move))
    return if _move_object.nil? || _move_object.direction.nil?

    value = MOVE_VALUE / _move_object.speed * _move_object.step
    increase_step(value)
    if value.to_i == MOVE_VALUE
      reset_move_object
      self.move_finished = true
    else
      self.move_finished = false
    end
  end

  sig { returns(T::Boolean) }
  def finished_moving?
    move_finished
  end

  private

  sig { params(value: Float).void }
  def increase_step(value)
    return unless value < MOVE_VALUE

    _move_object = T.must(move_object)
    move_value = 1.0 *
                 Directionable::GRID_VALUE[_move_object.direction.to_sym] /
                 _move_object.speed
    Directionable.dms_after_move!(
      dms, move: _move_object.direction, move_value: move_value
    )
    _move_object.step += 1
  end

  sig { void }
  def reset_move_object
    dms.x_grid = dms.x_grid.round
    dms.y_grid = dms.y_grid.round
    T.must(move_object).direction = nil
    T.must(move_object).step = 1
  end
end
