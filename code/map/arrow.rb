# typed: true
# frozen_string_literal: true

require_relative '../modules/directionable'
# rubocop:disable Metrics/ClassLength
class Arrow
  ARROW_SPRITE =
    Sprite.load_tiles(
      'assets/map_ui/MovementArrows_TRUE.png', 18, 18, retro: true
    )
  Part = Struct.new(:sprite, :direction, :is_corner)

  attr_accessor :body, :head, :last_move, :tail, :out_of_range, :head_dms
  attr_reader :body_sprite, :corner_sprite, :head_sprite, :tail_sprite
  def initialize
    clear
    build_sprites
  end

  def setup_arrow(move:, dms:)
    self.head_dms = Dimensioner.new(x_grid: dms.x_grid, y_grid: dms.y_grid)
    if Directionable.opposite_direction?(last_move, move)
      reduce_arrow
      return
    end
    self.tail = tail_sprite[move.to_sym] unless tail
    self.head = Part.new(head_sprite[move.to_sym], move)

    add_part_to_body(move)

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
    prev_dim = Dimensioner.new(x_grid: center, y_grid: center)
    tile_route.each do |tile|
      tile_dim = Dimensioner.new(x_grid: tile[1], y_grid: tile[0])
      move = Directionable.direction!(tile_dim, prev_dim, dms: dms)
      setup_arrow(move: move, dms: dms)
      prev_dim = tile_dim
    end
  end

  def draw(dimensioner)
    arrow_parts = arrow_exist? ? combined_body_head : []
    dms = dimensioner.dup
    draw_tail(dms.x_grid, dms.y_grid) if tail
    arrow_parts.each do |part|
      dms = Directionable.dms_after_move(dms, move: part.direction)
      draw_arrow_part(part.sprite, dms.x, dms.y)
    end
  end

  def length
    count_head = head ? 1 : 0
    body.size + count_head
  end

  def empty?
    body.empty?
  end

  private

  def reduce_arrow
    !empty? ? assign_new_head : remove_arrow
    self.last_move = head ? head.direction : nil
  end

  def add_part_to_body(move)
    if last_move == move
      add_straight_part
    elsif last_move
      add_corner_part(move)
    end
  end

  def add_straight_part
    body << Part.new(body_sprite[last_move.to_sym], last_move, false)
  end

  def add_corner_part(move)
    body << Part.new(
      corner_sprite[corner_direction(last_move, move)],
      last_move, true
    )
  end

  def assign_new_head
    last_part = body.pop
    return unless last_part.is_corner

    self.head = Part.new(head_sprite[last_part.direction.to_sym], last_part.direction)
  end

  def remove_arrow
    self.head = nil
    self.tail = nil
  end

  def corner_direction(last_move, move)
    "#{last_move.serialize}_#{move.serialize}".to_sym
  end

  def arrow_exist?
    head
  end

  def combined_body_head
    body + [head]
  end

  def draw_tail(x_grid, y_grid)
    tail.draw(
      Util.get_real_pos(x_grid),
      Util.get_real_pos(y_grid),
      GC::Z_UNIT - 1
    )
  end

  def draw_arrow_part(sprite, x, y)
    sprite.draw(x, y, GC::Z_ARROW)
  end

  def build_sprites
    @body_sprite = default_body_sprite
    @head_sprite = default_head_sprite
    @corner_sprite = default_corner_sprite
    @tail_sprite = default_tail_sprite
  end

  def default_tail_sprite
    {
      right: ARROW_SPRITE[0],
      left: ARROW_SPRITE[9],
      up: ARROW_SPRITE[8],
      down: ARROW_SPRITE[1]
    }
  end

  def default_corner_sprite
    {
      up_right: ARROW_SPRITE[4],
      left_down: ARROW_SPRITE[4],
      up_left: ARROW_SPRITE[5],
      right_down: ARROW_SPRITE[5],
      down_right: ARROW_SPRITE[12],
      left_up: ARROW_SPRITE[12],
      down_left: ARROW_SPRITE[13],
      right_up: ARROW_SPRITE[13]
    }
  end

  def default_head_sprite
    {
      right: ARROW_SPRITE[6],
      down: ARROW_SPRITE[7],
      up: ARROW_SPRITE[14],
      left: ARROW_SPRITE[15]
    }
  end

  def default_body_sprite
    {
      left: ARROW_SPRITE[3],
      right: ARROW_SPRITE[3],
      up: ARROW_SPRITE[2],
      down: ARROW_SPRITE[2]
    }
  end
end
# rubocop:enable Metrics/ClassLength