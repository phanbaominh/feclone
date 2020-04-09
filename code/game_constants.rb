require_relative 'tiler'
module GC
  SCALING_FACTOR = 3
  GRID_SIZE      = 16 * SCALING_FACTOR
  Z_BG, Z_UNIT, Z_CURSOR       = *0..2
  CURSOR_DELAY   = 100
  
  GBA_SCREEN_WIDTH = 240
  GBA_SCREEN_HEIGHT = 160
  ROOT_PATH = Pathname.new(".")
  CHARS_PATH = ROOT_PATH.join("assets", "character")
  PLAYER_CURSOR_SPRITE  = Tiler.new(file_path: "assets/map_ui/cursor.png", width: 32, height: 32).perform#Gosu::Image.load_tiles(, 32, 32, retro: true)
end