require 'rmagick'
if ARGV.size == 1
    image = Magick::ImageList.new(ARGV[0])
    result = Magick::ImageList.new

    5.times do |i|
        result << (image.crop(32 * i + i, 0, 32, 131))
    end

    image = result.append(false)
    result = Magick::ImageList.new

    4.times do |i|
        result << image.crop(0, 32 * i + i, 160, 32)
    end
    
    result.append(true).write("chopper/#{ARGV[0].split("/")[-1]}")
else 
    put "Wrong number of arguments"
end