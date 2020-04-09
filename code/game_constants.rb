module GC
  SCALING_FACTOR = 3
  GRID_SIZE      = 16 * SCALING_FACTOR
  Z_BG, Z_UNIT, Z_CURSOR       = *0..2
  CURSOR_DELAY   = 100
  PLAYER_CURSOR_SPRITE  = Gosu::Image.load_tiles("assets/map_ui/cursor.png", 32, 32, retro: true)[0..3]
  GBA_SCREEN_WIDTH = 240
  GBA_SCREEN_HEIGHT = 160

end