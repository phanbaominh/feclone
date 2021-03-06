# typed: true
# frozen_string_literal: true

class Movement
  attr_accessor :value, :type
  @movement_types = [:infantry]
  def initialize(value: 5, type: :infantry)
    @value = value
    @type  = type
  end
end
