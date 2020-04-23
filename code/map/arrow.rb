class Arrow
  ARROW_SPRITE = Gosu::Image.load_tiles("assets/map_ui/MovementArrows_TRUE.png", 18, 18, retro: true)
  GRID_VALUE = {
    left: -1,
    right: 1,
    up: -1,
    down: 1
  }
  HORIZONTAL = [:left, :right]
  VERTICAL = [:up, :down]
  attr_accessor :body, :head, :last_move, :tail
  attr_reader :body_sprite, :corner_sprite, :head_sprite, :tail_sprite

  def initialize
    clear
    build_sprites
  end

  def setup_arrow(move:)
    if opposite_direction?(last_move, move)
      if body.size > 0 
        last = self.body.pop 
        self.head = [head_sprite[last[1]], last[1]] if last[2]
      else 
        self.head = nil
        self.tail = nil
      end
      self.last_move = head ? head[1] : nil
      return
    end
    self.tail = tail_sprite[move] if !tail
    self.head = [head_sprite[move], move]
    if last_move == move 
      self.body << [body_sprite[last_move], last_move]
    elsif last_move
      self.body << [corner_sprite["#{last_move}_#{move}".to_sym], last_move, true]
    end
    self.last_move = move
  end

  def clear
    self.body = []
    self.tail = nil
    self.head = nil
    self.last_move = nil
  end

  def draw(dimensioner)
    arrow_parts = head ? body + [head] : []
    x_grid = dimensioner.x_grid
    y_grid = dimensioner.y_grid
    tail.draw(Util.get_real_pos(x_grid), Util.get_real_pos(y_grid), GC::Z_UNIT - 1, GC::SCALING_FACTOR, GC::SCALING_FACTOR) if tail
    arrow_parts.each do |sprite|
      x_grid = x_grid_value(x_grid, sprite[1])
      y_grid = y_grid_value(y_grid, sprite[1])
      real_x = Util.get_real_pos(x_grid)
      real_y = Util.get_real_pos(y_grid)
      sprite[0].draw(real_x, real_y, GC::Z_ARROW, GC::SCALING_FACTOR, GC::SCALING_FACTOR)
    end
  end

  def length
    count_head = head ? 1 : 0
    body.size + count_head
  end
  private

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

  def opposite_direction?(last_move, move)
    same_axis?(last_move, move) && last_move != move
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