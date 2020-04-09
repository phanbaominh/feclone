module Buttonable
  def handle_buttons
    return if !pre_handling
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
    button == Gosu::KB_DOWN || button == Gosu::KB_UP || button == Gosu::KB_RIGHT || button == Gosu::KB_LEFT
  end
end