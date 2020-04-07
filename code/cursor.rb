class Cursor
    attr_reader :sprite, :x_grid, :y_grid
    attr_writer :x_grid, :y_grid
    def initialize(x_grid: 0, y_grid: 0, z: Main::Z_CURSOR, image: Main::IMAGE_CURSOR)
        @x_grid = x_grid
        @y_grid = y_grid
        @time = 0
        @sprite = Drawable.new(z: z, image: image)
    end

    def button_handle
        if Gosu::milliseconds - @time > 100
            if Gosu.button_down? Gosu::KB_DOWN 
                self.y_grid += 1
                puts 1
            end
            if Gosu.button_down? Gosu::KB_UP
                self.y_grid -= 1
            end
            if Gosu.button_down? Gosu::KB_RIGHT
                self.x_grid += 1
            end
            if Gosu.button_down? Gosu::KB_LEFT
                self.x_grid -= 1
            end
            @time = Gosu::milliseconds
        end
        
    end

    def draw
        sprite.x = x_grid * Main::GRID_SIZE
        sprite.y = y_grid * Main::GRID_SIZE

        sprite.draw
    end
end