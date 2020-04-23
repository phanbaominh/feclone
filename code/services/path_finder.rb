require_relative 'service'
class PathFinder < Service
  attr_reader :terrains, :move_costs, :movement, :paths, :center
  def initialize(terrains, dimensioner, movement)
    @movement = movement
    @center = movement.value
    @paths = []
    @move_costs = []
    size = movement.value * 2 + 1

    (movement.value * 2 + 1).times do 
        @move_costs << ['#'] * size
        @paths << []
    end
    build_move_array(terrains, dimensioner.x_grid, dimensioner.y_grid) 
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
    paths
  end
  
  private
  def build_move_array(terrains, x, y)
    #puts Util.prettify(move_costs)
    move_costs.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        offset_i = y + i - center
        offset_j = x + j - center
        next if offset_i < 0 || offset_j < 0 || offset_i >= terrains.size || offset_j >= terrains[0].size
        if dist(center, center, i ,j) > movement.value
          move_costs[i][j] = '#'
        else
          move_costs[i][j] = Terrain.get_terrain(name: terrains[offset_i][offset_j]).move_cost(movement.type)
        end
      end
    end
  end

  def dist(x, y, x2, y2)
    return (x - x2).abs + (y - y2).abs
  end

  def find_path(arr, srcx, srcy, destx, desty, move)
    if arr[destx][desty] == "#"
        return nil
    end

    return [] if destx == srcx && desty == srcy && move>=0
    return false if move < 0
    return paths[destx][desty].dup if paths[destx][desty] && paths[destx][desty] != "#" && move >= paths[destx][desty][0][2
    ]
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
      arr[destx][desty], current_move_cost = "#", arr[destx][desty]
      res = find_path(arr, srcx, srcy, dest[0], dest[1], move - current_move_cost)
      arr[destx][desty] = current_move_cost
      if res
        sum_move = !res.empty? ? res[-1][2]  : 0
        return false if move  < sum_move + current_move_cost
        res << [destx, desty, sum_move + current_move_cost]
        self.paths[destx][desty] = res.dup
        return res
      end
     
    end
    res
  end

end