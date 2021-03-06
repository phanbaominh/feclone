# typed: true
# frozen_string_literal: true

module Highlighter
  def self.build_highlighter(sprite:)
    # p "Size: #{sprite.size}"
    Animator.new(sprite: sprite, times_per_frame: [50] * sprite.size)
  end

  def self.draw(const:, x_grid:, y_grid:)
    highlighter = const_get(const)
    dms = Dimensioner.new(x_grid: x_grid, y_grid: y_grid, z: GC::Z_HIGHLIGHT)
    highlighter.dms = dms
    highlighter.draw
  end

  ACTIVE_BLUE_HLT_PATH = 'assets/map_ui/highlights/BlueHighlight.png'
  HOVER_BLUE_HLT_PATH = 'assets/map_ui/highlights/LightBlueHighlight.png'
  ACTIVE_BLUE_HIGHLIGHTER = build_highlighter(
    sprite: Sprite.load_tiles(ACTIVE_BLUE_HLT_PATH, 16, 16, retro: true)
  )
  HOVER_BLUE_HIGHLIGHTER = build_highlighter(
    sprite: Sprite.load_tiles(HOVER_BLUE_HLT_PATH, 16, 16, retro: true)
  )
end
