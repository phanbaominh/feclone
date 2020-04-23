module Dimensionable
  def x_grid=(value)
    dimensioner.x_grid = value
  end

  def y_grid=(value)
    dimensioner.y_grid = value
  end
  
  def x_grid
    dimensioner.x_grid
  end

  def y_grid
    dimensioner.y_grid
  end

  def dimensioner
    @dimensioner
  end

  def dimensioner=(value)
    @dimensioner = value
  end
end