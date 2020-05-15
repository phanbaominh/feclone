module Directionable
  GRID_VALUE = {
    left: -1,
    right: 1,
    up: -1,
    down: 1
  }
  HORIZONTAL = [:left, :right]
  VERTICAL = [:up, :down]

  def opposite_direction?(last_move, move)
    same_axis?(last_move, move) && last_move != move
  end
  
  private
  

  def direction!(tile_dms, prev_tile_dms, dms: nil)
    delta_x = tile_dms.x_grid - prev_tile_dms.x_grid
    delta_y = tile_dms.y_grid - prev_tile_dms.y_grid

    if dms
      dms.x_grid += delta_x
      dms.y_grid += delta_y
    end

    if delta_x !=0
      move = delta_x > 0 ? :right : :left
    else
      move = delta_y > 0 ? :down : :up
    end
    move
  end

  def dms_after_move(dms, move: nil, move_value: nil)
    delta_x = 0
    delta_y = 0
    move_value ||= GRID_VALUE[move]
    delta_x = move_value if horizontal?(move)
    delta_y = move_value if vertical?(move)
    #p dms
    Dimensioner.new(
      **{
      x_grid: dms.x_grid + delta_x,
      y_grid: dms.y_grid + delta_y,
      z: dms.z,
      x_offset:  dms.x_offset,
      y_offset: dms.y_offset,
      }
    )
  end


  def horizontal?(move)
    HORIZONTAL.include?(move)
  end

  def vertical?(move)
    VERTICAL.include?(move)
  end

  def same_axis?(last_move, move)
    (horizontal?(move) && horizontal?(last_move)) || (vertical?(move) && vertical?(last_move))
  end
end