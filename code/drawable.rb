module Drawable
  def draw(x: 0, y: 0, z: 0, x_scale: GameConstants::SCALING_FACTOR, y_scale: GameConstants::SCALING_FACTOR)
    return if !pre_draw
    image = animatable.get_frame if animatable?
    image.draw(x, y, z, x_scale, y_scale)
    post_draw
  end

  def animatable?
    !animatable.nil?
  end

  def pre_draw
    true
  end

  def post_draw
  end
end