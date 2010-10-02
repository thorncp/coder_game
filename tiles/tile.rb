class Tile
  def initialize(window, resources)
  end
  
  def draw(x, y, z)
  end
  
  def passable?
    false
  end
  
  def self.passable
    define_method :passable? do
      true
    end
  end
end