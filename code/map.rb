class Map
  attr_accessor :sprite, :tiles

  def initialize(
      sprite: nil,
      tiles: nil
  )
    @sprite = sprite
    @tiles = set_up_tiles
    test_tiles
  end

  def draw
    sprite.draw(0, 0, 0, GC::SCALING_FACTOR, GC::SCALING_FACTOR)
    tiles.each do |row|
        row.each do |tile|
            tile.draw
        end
    end
  end
  
  def add_unit(x, y, unit)
    tiles[x][y].unit = unit
  end

  def unit_present?(x, y)
    tiles[x][y].unit
  end
  
  def get_unit(x,y)
    tile[x][y].unit
  end

  private

  def set_up_tiles
    tiles = []
    sprite.width_grid.to_i.times do |i|
        column = []
        sprite.height_grid.to_i.times do |j|
            column << Tile.new(dimensioner: Dimensioner.new(x_grid: i, y_grid: j))
        end
        tiles << column
    end
    tiles
  end

  def test_tiles
    4.times do |i|
        4.times do |j|
            unit = Unit.new(sprite: Gosu::Image.load_tiles("assets/character/map_sprites/eirika.png", 32, 32, retro: true))
            add_unit(4 * j, 2 * i, unit)
        end
    end
  end
end