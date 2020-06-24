# typed: false
# frozen_string_literal: true

require_relative 'service'
class PathFinder < Service
  attr_reader :terrains, :move_costs, :movement, :paths, :center
  def initialize(terrains, dimensioner, movement)
    @movement = movement
    @center = movement.value
    @paths = []
    @move_costs = []
    size = movement.value * 2 + 1

    size.times do
      @move_costs << [nil] * size
      @paths << []
    end
    build_move_array(terrains, dimensioner.x_grid, dimensioner.y_grid)
  end

  def perform
    # puts Util.prettify(move_costs)
    find_all_paths
    paths[center][center] = :center
    paths
  end

  private

  def find_all_paths
    move_costs.each_with_index do |row, i|
      row.each_with_index do |_, j|
        next if paths[i][j]

        find_path(
          move_costs, movement.value, movement.value, i, j, movement.value
        )
      end
    end
  end

  def build_move_array(terrains, x, y)
    move_costs.each_with_index do |row, i|
      row.each_with_index do |_tile, j|
        offset_i = y + i - center
        offset_j = x + j - center
        if offset_i.negative? || offset_j.negative? ||
           offset_i >= terrains.size ||
           offset_j >= terrains[0].size
          next
        end
        next unless dist(center, center, i, j) <= movement.value

        terrain_name = terrains[offset_i][offset_j]
        terrain = Terrain.get_terrain(name: terrain_name)
        move_costs[i][j] = terrain.move_cost(movement.type)
      end
    end
  end

  def dist(x, y, x2, y2)
    (x - x2).abs + (y - y2).abs
  end

  # rubocop:disable all
  def find_path(arr, srcx, srcy, curx, cury, move)
    return nil if !tile_traversable?(arr, curx, cury) || out_of_move_cost?(move)
    return [] if reached_src_tile?(srcx, srcy, curx, cury, move)
    if subpath_already_found_and_traversible?(curx, cury, move)
      return paths[curx][cury].dup
    end

    next_tiles = sorted_next_tiles_on_distance(arr, srcx, srcy, curx, cury)
    result = nil
    next_tiles.each do |tile|
      current_move_cost = arr[curx][cury]
      arr[curx][cury] = nil
      result = find_path(
        arr, srcx, srcy, tile[0], tile[1], move - current_move_cost
      )
      arr[curx][cury] = current_move_cost

      if result
        return assign_result_to_paths(
          result, curx, cury, current_move_cost, move
        )
      end
    end
    result
  end

  # rubocop:enable all
  def subpath_already_found_and_traversible?(curx, cury, move)
    paths[curx][cury] && move >= paths[curx][cury][0][2]
  end

  def out_of_move_cost?(move)
    move.negative?
  end

  def tile_traversable?(arr, x, y)
    arr[x][y]
  end

  def reached_src_tile?(srcx, srcy, curx, cury, move)
    curx == srcx && cury == srcy && !out_of_move_cost?(move)
  end

  # rubocop:disable Metrics/AbcSize
  def sorted_next_tiles_on_distance(arr, srcx, srcy, curx, cury)
    xa = [1, -1, 0, 0]
    ya = [0, 0, 1, -1]
    next_tiles = []
    4.times do |i|
      x = curx + xa[i]
      y = cury + ya[i]
      if x >= 0 && y >= 0 && x < arr[0].size && y < arr.size && arr[x][y]
        next_tiles << [x, y, dist(srcx, srcy, x, y)]
      end
    end

    next_tiles.sort { |a, b| a[2] <=> b[2] }
  end

  # rubocop:enable Metrics/AbcSize
  def assign_result_to_paths(result, curx, cury, current_movecost, move)
    sum_movecost = !result.empty? ? result[-1][2] : 0
    return false if move < sum_movecost + current_movecost

    result << [curx, cury, sum_movecost + current_movecost]
    paths[curx][cury] = result.dup
    result
  end
end
