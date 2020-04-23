require_relative '../modules/buttonable'
class MapHandler
  include Buttonable
  attr_accessor :map, :cursor, :buttons
  def initialize(map: nil, cursor: nil)
    @map = map
    @cursor = cursor
    @buttons = {
      KB_DOWN:  true,
      KB_UP:    true,
      KB_RIGHT: true,
      KB_LEFT:  true,
      KB_Z: true,
      KB_X: true
    }
    change_cursor_state
  end
  
  def draw
    cursor.draw
    map.draw
  end
  private

  ######################
  #BUTTONABLE INTERFACE#
  ######################
  def pre_handling
    
    !cursor.debounced?
  end
  
  def pre_press(button)
    if movement_button?(button)
      change_cursor_state(move_out: true)
    end
  end

  def post_press(button)
    if movement_button?(button)
      change_cursor_state
    end
  end
  
  def kb_z
    if  unit = unit_focused?
      unit.change_ani_state(:down)
      #p map.terrains
      #p unit.dimensioner
      #p unit.movement
      unit.add_moveable_tiles(moveable_tiles: PathFinder.perform(map.terrains, unit.dimensioner, unit.movement))
      unit.change_highlighter_state(state: :active, offset: unit.movement.value)
    end
  end

  def kb_x
    unit = unit_focused?
    if  unit && unit.map_sprite.highlighter_state == :active
      unit.change_highlighter_state(state: :idle)
      unit.change_ani_state(:selected)
    end
  end
  def kb_down
    cursor.y_grid += 1
  end

  def kb_up
    cursor.y_grid -= 1
  end

  def kb_right
    cursor.x_grid += 1
  end
  
  def kb_left
    cursor.x_grid -= 1
  end
  
  def change_cursor_state(move_out: false)
    unit = unit_focused?
    if unit && move_out
      unit.change_ani_state(:idle)
      cursor.ani_state = :idle
    elsif unit && cursor.ani_state == :idle
      cursor.ani_state = :selected
      unit.change_ani_state(:selected)
    elsif !unit && cursor.ani_state == :selected
      cursor.ani_state = :idle
    end
  end

  def unit_focused?
    map.unit_present?(cursor.x_grid, cursor.y_grid)
  end
end