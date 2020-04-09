module Util
  def self.get_real_pos(pos)
    pos * GC::GRID_SIZE
  end
end