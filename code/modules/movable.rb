module Movable
  MOVE_VALUE = 1.0
  include Directionable
  Move = Struct.new(:direction, :speed, :step)
  attr_accessor :move_object
  def move(direction, speed)
    self.move_object = Move.new(direction, speed, 1)
  end
  
  def finished_moving?
    return true if !move_object || !move_object.direction
    value =  MOVE_VALUE / move_object.speed * move_object.step

    if value < MOVE_VALUE
      move_value = 1.0 * GRID_VALUE[move_object.direction] / move_object.speed
      self.dms = dms_after_move(dms, move: move_object.direction, move_value: move_value)
      self.move_object.step += 1
    end
    
    if value.to_i == MOVE_VALUE
      self.dms.x_grid = self.dms.x_grid.round
      self.dms.y_grid = self.dms.y_grid.round
      self.move_object.direction = nil
      self.move_object.step = 1
      true
    else
      false
    end
  end
end