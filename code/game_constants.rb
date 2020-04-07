module GameConstants
  SCALING_FACTOR = 3
  GRID_SIZE      = 16 * SCALING_FACTOR
  Z_CURSOR       = 2
  CURSOR_DELAY   = 100
  PLAYER_CURSOR_SPRITE  = Gosu::Image.load_tiles("assets/map_ui/cursor.png", 32, 32, retro: true)[0..3].collect{ |tile| tile.subimage(6, 4, 20, 21)}
end