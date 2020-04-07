class Drawable
    SCALING_FACTOR = 3
    attr_accessor :x, :y, :z, :image
    def initialize(x: 0, y: 0, z: 0, image: nil)
        @x = x
        @y = y
        @z = z
        @image = image
    end

    def draw
        image.draw(x, y, z, SCALING_FACTOR, SCALING_FACTOR)
    end
end