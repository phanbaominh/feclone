module Incld
    def self.included(mod)
        @custom = "gay"
        p "haha"
        attr_accessor :custom
    end
end
class Gay
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
s = Gay.new
p s.a += 2
p s.a
p s.b
p s.custom