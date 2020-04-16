require_relative 'service'
class PathFinder < Service
  attr_reader :terrains, :move_costs, :movement, :paths
  def initialize(terrains, dimensioner, movement)
    @movement = movement
    @move_costs = build_move_array(terrains, dimensioner.x_grid, dimensioner.y_grid)
    @paths = []
    (move_costs.size).times do
        @paths << []
    end 
  end

  def perform
    move_costs.each_with_index do |row, i|
      path_row = []
      row.each_with_index do |_, j|
        if !paths[i][j]
            self.paths[i][j] = "#" if !find_path(move_costs, movement.value, movement.value, i, j, movement.value)
        end
      end
    end
  end
  
  private
  def build_move_array(terrains, x, y)
    move = []
    terrains.each_with_index do |row, i|
      if i >= y - movement.value && i <= y + movement.value
        move_row = []
        row.each_with_index do |tile, j|
            if j >= x - movement.value && j <= x + movement.value
                if dist(y, x, i ,j) > movement.value
                  move_row << '#'
                else
                  move_row << Terrain.get_terrain(name: terrains[i][j]).move_cost(movement.type)
                end
            end
        end
        move << move_row
      end
    end
    move 
  end

  def dist(x, y, x2, y2)
    return (x - x2).abs + (y - y2).abs
  end

  def find_path(arr, srcx, srcy, destx, desty, move)
    if arr[destx][desty] == "#"
        return nil
    end
    return paths[destx][desty] if paths[destx][desty] && paths[destx][desty] != "#"
    return [] if destx == srcx && desty == srcy && move>=0
    move -= arr[destx][desty].to_i
    return false if move < 0
  
    xa = [1, -1, 0, 0]
    ya = [0, 0, 1, -1]
    dests = []
    
    4.times do |i|
      x = destx + xa[i]
      y = desty + ya[i]
      if x >= 0 && y >= 0 && x < arr.size && y < arr.size && arr[x][y] != "#"
          dests << [x, y, dist(srcx, srcy, x, y)]
      end
    end
    
    dests = dests.sort{|a, b| a[2] <=> b[2]}
    res = nil
  
    dests.each do |dest|  
      arr[destx][desty], tmp = "#", arr[destx][desty]
      res = find_path(arr, srcx, srcy, dest[0], dest[1], move)
      arr[destx][desty] = tmp 
      if res
        self.paths[destx][desty] = (res << [destx, desty]).dup
        return res
      end
  
    end
    res
  end

end