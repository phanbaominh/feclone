# frozen_string_literal: true

class Service
  def self.perform(*args, &block)
    new(*args, &block).perform
  end
end
