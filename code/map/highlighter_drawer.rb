# frozen_string_literal: true

class HighlighterDrawer
  attr_reader :map_sprite, :move_value
  attr_accessor :state

  def initialize
    @state = :idle
  end

  def draw
    movable_tiles = map_sprite.movable_tiles
    return unless movable_tiles && state != :idle

    movable_tiles.each_with_index do |row, i|
      row.each_with_index do |movable_tile, j|
        next unless movable_tile

        draw_highlighter(i, j)
      end
    end
  end

  def bind_unit(unit:)
    @map_sprite = unit.map_sprite
    @move_value = unit.movement.value
  end

  private

  def draw_highlighter(i, j)
    Highlighter.draw(
      const: highlighter_const_name,
      x_grid: map_sprite.x_grid + (j - move_value),
      y_grid: map_sprite.y_grid + (i - move_value)
    )
  end

  def highlighter_const_name
    "#{state.upcase}_BLUE_HIGHLIGHTER"
  end
end