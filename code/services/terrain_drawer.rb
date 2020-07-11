# typed: true
# frozen_string_literal: true

class TerrainDrawer
  attr_reader :sprite
  def initialize(sprite = nil)
    @sprite = sprite
  end

  def perform
    result = []
    sprite.each do |row|
      row_res = []
      row.each do |image|
        hex_code = image.pixel_color(0, 0)
                        .to_color(Magick::AllCompliance, false, 8, true)[1..]
        hex_code = ('c' + hex_code).to_sym.downcase
        terrain_name = Terrain::TERRAIN_COLOR[hex_code] || :default
        row_res << terrain_name
      end
      result << row_res
    end

    result
  end
end
