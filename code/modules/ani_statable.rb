module AniStatable
  def ani_state
    @ani_stators.ani_state
  end

  def ani_state=(value)
    @ani_stators.ani_state = value
  end

  def animators
    @ani_stators.animators
  end

  def animators=(value)
    @ani_stators.animators = value
  end

  def dms=(value)
    @dms = value
    @ani_stators.dms = value
  end

  def dms
    @dms
  end
end