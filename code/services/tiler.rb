# typed: true
# frozen_string_literal: true

class Tiler < Service
  attr_reader :sprite, :width, :height, :grid
  def initialize(file_path = '', grid = false, width = 16, height = 16)
    @sprite = Magick::ImageList.new(file_path)
    @width = width
    @height = height
    @grid = grid
  end

  def perform
    result = []
    grid_width = sprite.columns / width
    grid_height = sprite.rows / height
    grid_height.times do |i|
      row = []
      grid_width.times do |j|
        row << sprite.crop(j * width, i * height, width, height)
      end
      result << row
    end
    result = result.flatten unless grid
    result
  end
end
