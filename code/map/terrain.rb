class Terrain
  attr_accessor :types, :effect

  TERRAIN_TYPES = {
      plain: {types: {infantry: 1}},
      hill: {types: {infantry: 3}},
      forest: {types: {infantry: 2}},
      cliff: {types: {}},
      sea: {types: {}},
      fort: {types: {infantry: 2}},
      village: {types: {infantry: 1}},
      default: {types: {}}
  }
  TERRAIN_COLOR = {
    c98fb98: :plain,
    c228b22: :forest,
    cdaa520: :hill,
    c00000b: :default,
    c8b4513: :cliff,
    c00008b: :sea,
    cd0c850: :fort,
    cb00000: :village
  }

  def self.get_terrain(name: :default)
    Terrain.new(TERRAIN_TYPES[name])
  end

  def initialize(options = {})
    options = default_value(options)
    @types = options[:types]
    @effect = options[:effect]
    @name = options[:name]
  end

  def terrain
    @terrain.name
  end

  def terrain=(value)
    @terrain = TERRAIN_TYPES[value]
  end
  
  def move_cost(type)
    types[type] ? types[type] : '#'
  end
  private

  def default_value(options)
    options[:types] ||= {}
    options[:effect] ||= nil
    options[:name] ||= :default
    
    options
  end
end
