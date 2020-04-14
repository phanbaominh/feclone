class TerrainDrawer < Service
  attr_reader :sprite
  def initialize(sprite = nil)
    @sprite = sprite
  end

  def perform
    result = []
    sprite.each do |row|
        row_res = []
        row.each do |image|
          hexcode = image.pixel_color(0, 0).to_color(Magick::AllCompliance, false, 8, true)[1..]
          hexcode = ('c' + hexcode).to_sym.downcase
          terrain_name = Terrain::TERRAIN_COLOR[hexcode] || :default
          row_res << terrain_name
        end
        result << row_res
    end

    result
  end
end