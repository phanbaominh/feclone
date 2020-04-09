class Tiler
  attr_accessor :sprite, :width, :height
  def initialize(file_path: "",  width: 16, height: 16)
    @sprite = Magick::ImageList.new(file_path)
    @width = width
    @height = height
  end
  
  def perform
    result = []
    grid_width = sprite.columns / width
    grid_height = sprite.rows / height
    
    grid_height.times do |i|
        grid_width.times do |j|
            result << sprite.crop(j * width, i * height, width, height)
        end
    end

    result
  end
end

#Tiler.new(file_path: Pathname.new("test.png"), width: 64, height: 64).perform.each_with_index{|pic, index| pic.write("pic1_#{index}.png")}