module Buttonable
  def handle_buttons
    return if !pre_handling
    buttons.each do |k, _|
      handle_button(k)
    end
    post_handling
  end

  def handle_button(button)
    if Gosu.button_down? Gosu.const_get(button)
      send(button.downcase)
      post_press
    end
  end

  def post_press
  end

  def pre_handling
    true
  end

  def post_handling
  end
end