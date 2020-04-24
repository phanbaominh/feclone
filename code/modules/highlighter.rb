module Highlighter
    def self.build_highlighter(sprite:)
        #p "Size: #{sprite.size}"
        Animator.new(sprite: sprite, times_per_frame: [50] * sprite.size)
    end

    def self.draw(const:, x_grid:, y_grid:)
        const_get(const).draw(dimensioner_arg: Dimensioner.new(x_grid: x_grid, y_grid: y_grid, z: GC::Z_HIGHLIGHT))
    end
    ACTIVE_BLUE_HIGHLIGHTER = build_highlighter(sprite: Gosu::Image.load_tiles("assets/map_ui/highlights/BlueHighlight.png", 16, 16, retro: true))
    HOVER_BLUE_HIGHLIGHTER = build_highlighter(sprite: Gosu::Image.load_tiles("assets/map_ui/highlights/LightBlueHighlight.png", 16, 16, retro: true))
end