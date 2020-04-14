class Service
  def self.perform(*args, &block)
    new(*args,&block).perform
  end
end