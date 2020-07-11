# typed: true
# frozen_string_literal: true

module Buttonable
  include Kernel
  attr_accessor :buttons
  def handle_buttons
    return post_handling unless pre_handling

    # TODO: HANDLE 2 buttons press
    buttons.each do |k, _|
      handle_button(k)
    end
    post_handling
  end

  def handle_button(button)
    button_value = Gosu.const_get(button)
    return unless Gosu.button_down? button_value

    pre_press(button_value)
    send(button.downcase) if respond_to?(button.downcase)
    post_press(button_value)
  end

  def pre_press(button); end

  def post_press(button); end

  def pre_handling
    true
  end

  def post_handling; end

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
  end
end
