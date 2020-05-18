# frozen_string_literal: true

require_rel 'services'
module GC
  SCALING_FACTOR = 3
  GRID_SIZE      = 16 * SCALING_FACTOR
  Z_BG, Z_HIGHLIGHT, Z_UNIT, Z_ARROW, Z_CURSOR = *0..4
  GBA_SCREEN_WIDTH = 240
  GBA_SCREEN_HEIGHT = 160
  ROOT_PATH = Pathname.new('.')
  CHARS_PATH = ROOT_PATH.join('assets', 'character')
end
