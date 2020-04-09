require "pathname"
module Incld
    def self.included(mod)
        @custom = "gay"
        p "haha"
        attr_accessor :custom
    end

    def defineds?
        instance_variable_defined?(:@c)
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
p s.defineds?
p File.dirname(__FILE__)