require "pathname"
module Incld
    def self.included(mod)
        @custom = "haha"
        p "haha"
        attr_accessor :custom
    end

    def defineds?
        instance_variable_defined?(:@c)
    end
end
class Haha
    include Incld
    attr_reader :a
    attr_accessor :b
    def initialize
        @a = 0
        @b = 0
    end
    def a=(value)
        self.b = value * 2
        @a = value
    end

    
end

def dist(x, y, x2, y2)
    return (x - x2).abs + (y - y2).abs
end

def load_file(file)
    file_data = nil
    File.open(file, "r") do |f|
      file_data = f.readlines.map do |line|
        line.chomp.split(" ")
      end
    end
    file_data
end
def prettify(array)
    array.map{ |a| a.map { |i| i.to_s.rjust(2) }.join }
end
def find_path(arr, srcx, srcy, destx, desty, move)
 
  return [] if destx == srcx && desty == srcy && move>=0
  move -= arr[destx][desty].to_i
  return false if move < 0

  xa = [1, -1, 0, 0]
  ya = [0, 0, 1, -1]
  dests = []
  
  4.times do |i|
    x = destx + xa[i]
    y = desty + ya[i]
    if x >= 0 && y >= 0 && x < arr.size && y < arr.size && arr[x][y] != "#"
        dests << [x, y, dist(srcx, srcy, x, y)]
    end
  end
  
  dests = dests.sort{|a, b| a[2] <=> b[2]}
  res = nil

  dests.each do |dest|  
    arr[destx][desty], tmp = "#", arr[destx][desty]
    res = find_path(arr, srcx, srcy, dest[0], dest[1], move)
    arr[destx][desty] = tmp 
    return res << [destx, desty] if res

  end
  res
end

#puts prettify(load_file("text.txt"))
#p find_path(load_file("text.txt"), 5, 5, 2, 4, 5)
class Test
  
  attr_accessor :a
  def initialize
    @a = []
  end
  
  def self.gay
    2
  end

  B = gay
end

test = Test.new
p test.instance_variable_get(:@b)
puts test.a
puts Test::B