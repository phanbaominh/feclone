class Arrow
  ARROW_SPRITE = Sprite.load_tiles("assets/map_ui/MovementArrows_TRUE.png", 18, 18, retro: true)
  GRID_VALUE = {
    left: -1,
    right: 1,
    up: -1,
    down: 1
  }
  HORIZONTAL = [:left, :right]
  VERTICAL = [:up, :down]
  attr_accessor :body, :head, :last_move, :tail, :out_of_range, :head_dms
  attr_reader :body_sprite, :corner_sprite, :head_sprite, :tail_sprite
  Part = Struct.new(:sprite, :direction, :is_corner)

  def initialize
    clear
    build_sprites
  end

  def setup_arrow(move:, dms:)
    self.head_dms = Dimensioner.new(x_grid: dms.x_grid, y_grid: dms.y_grid)
    if opposite_direction?(last_move, move)
      if body.size > 0 
        last = self.body.pop  
        self.head = Part.new(head_sprite[last.direction], last.direction) if last.is_corner
      else 
        remove_arrow
      end
      self.last_move = head ? head.direction : nil
      return
    end
    self.tail = tail_sprite[move] if !tail
    self.head = Part.new(head_sprite[move], move)

    if last_move == move 
      self.body << Part.new(body_sprite[last_move], last_move, false)
    elsif last_move
      self.body << Part.new(corner_sprite[corner_direction(last_move, move)], last_move, true)
    end

    self.last_move = move
  end

  def clear
    self.body = []
    self.tail = nil
    self.head = nil
    self.last_move = nil
    self.head_dms = nil
  end

  def build_arrow(tile_route:, center:, dms:)
    clear
    prev_dim = [center, center]
    tile_route.each do |tile|
      tile_dim = tile[0..1]
      move, dms = direction(tile_dim, prev_dim, dms)
      setup_arrow(move: move, dms: dms)
      prev_dim = tile_dim
    end
  end
  def draw(dimensioner)
    arrow_parts = arrow_exist? ? combined_body_head : []
    x_grid = dimensioner.x_grid
    y_grid = dimensioner.y_grid
    draw_tail(x_grid, y_grid) if tail
    arrow_parts.each do |part|
      x_grid = x_grid_value(x_grid, part.direction)
      y_grid = y_grid_value(y_grid, part.direction)
      real_x = Util.get_real_pos(x_grid)
      real_y = Util.get_real_pos(y_grid)
      draw_arrow_part(part.sprite, real_x, real_y)
    end
  end

  def length
    count_head = head ? 1 : 0
    body.size + count_head
  end

  def opposite_direction?(last_move, move)
    same_axis?(last_move, move) && last_move != move
  end

  private

  def direction(tile_dms, prev_tile_dms, dms)
    delta_y = tile_dms[0] - prev_tile_dms[0]
    delta_x = tile_dms[1] - prev_tile_dms[1]
    dms.x_grid += delta_x
    dms.y_grid += delta_y
    if delta_x !=0
      move = delta_x > 0 ? :right : :left
    else
      move = delta_y > 0 ? :down : :up
    end
    [move, dms]
  end

  def remove_arrow
    self.head = nil
    self.tail = nil
  end

  def corner_direction(last_move, move)
    "#{last_move}_#{move}".to_sym
  end

  def arrow_exist?
    head
  end

  def combined_body_head
    body + [head]
  end

  def draw_tail(x_grid, y_grid)
    tail.draw(Util.get_real_pos(x_grid), Util.get_real_pos(y_grid), GC::Z_UNIT - 1)
  end

  def draw_arrow_part(sprite, x, y)
    sprite.draw(x, y, GC::Z_ARROW)
  end

  def x_grid_value(x, move)
    delta = 0
    delta = GRID_VALUE[move] if HORIZONTAL.include?(move)
    x + delta
  end

  def y_grid_value(y, move)
    delta = 0
    delta = GRID_VALUE[move] if VERTICAL.include?(move)
    y + delta
  end

  def horizontal?(move)
    HORIZONTAL.include?(move)
  end

  def vertical?(move)
    VERTICAL.include?(move)
  end

  def same_axis?(last_move, move)
    (horizontal?(move) && horizontal?(last_move)) || (vertical?(move) && vertical?(last_move))
  end

  

  def build_sprites
    @body_sprite  = {
        left: ARROW_SPRITE[3],
        right: ARROW_SPRITE[3],
        up: ARROW_SPRITE[2],
        down: ARROW_SPRITE[2]
    }
    @head_sprite = {
        right: ARROW_SPRITE[6],
        down: ARROW_SPRITE[7],
        up: ARROW_SPRITE[14],
        left: ARROW_SPRITE[15]
    }
    @corner_sprite = {
        up_right: ARROW_SPRITE[4],
        left_down: ARROW_SPRITE[4],
        up_left: ARROW_SPRITE[5],
        right_down: ARROW_SPRITE[5],
        down_right: ARROW_SPRITE[12],
        left_up: ARROW_SPRITE[12],
        down_left: ARROW_SPRITE[13],
        right_up: ARROW_SPRITE[13]
    }
    @tail_sprite = {
        right: ARROW_SPRITE[0],
        left: ARROW_SPRITE[9],
        up: ARROW_SPRITE[8],
        down: ARROW_SPRITE[1]
    }
  end

  
end