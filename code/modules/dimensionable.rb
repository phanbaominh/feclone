module Dimensionable
  def x_grid=(value)
    dms.x_grid = value
  end

  def y_grid=(value)
    dms.y_grid = value
  end
  
  def x_grid
    dms.x_grid
  end

  def y_grid
    dms.y_grid
  end

  def dms=(value)
    @dms.mutate(value)
    #@ani_stators.dms = value
  end

  def dms
    @dms
  end
  
end