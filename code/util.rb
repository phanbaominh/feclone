module Util
  def self.get_real_pos(pos)
    pos * GC::GRID_SIZE
  end

  def self.prettify(array)
    array.map{ |a| a.map { |i| i.to_s.rjust(2) }.join }
  end
end