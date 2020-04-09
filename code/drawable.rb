module Drawable
  def draw(x_scale: GC::SCALING_FACTOR, y_scale: GC::SCALING_FACTOR)
    return if !pre_draw
    image = animatable? ? animator.get_frame : sprite
    !custom_draw? ? image.draw(*dimensioner.get_3d, x_scale, y_scale) : custom_draw(image)
    post_draw
  end

  def animatable?
    !animator.nil?
  end

  def pre_draw
    true
  end

  def post_draw
  end

  def custom_draw?
    false
  end

end