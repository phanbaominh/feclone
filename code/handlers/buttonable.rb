module Buttonable
  def handle_buttons
    return if !pre_handling
    #TODO: HANDLE 2 buttons press
    buttons.each do |k, _|
      handle_button(k)
    end
    post_handling
  end

  def handle_button(button)
    button_value = Gosu.const_get(button)
    if Gosu.button_down? button_value
      pre_press(button_value)
      send(button.downcase)
      post_press(button_value)
    end
  end
  
  def pre_press(button)
  end

  def post_press(button)
  end
  
  def pre_handling
    true
  end

  def post_handling
    
  end

  def movement_button?(button)
    case button
    when Gosu::KB_DOWN
      :down
    when Gosu::KB_UP
      :up
    when Gosu::KB_RIGHT
      :right
    when Gosu::KB_LEFT
      :left
    else
      false
    end
    #button == Gosu::KB_DOWN || button == Gosu::KB_UP || button == Gosu::KB_RIGHT || button == Gosu::KB_LEFT
  end
end