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
  
  def hittable?
    false
  end
  
  def self.hittable
    define_method :hittable? do
      true
    end
  end
  
  def action(actor)
  end
  
  def hit(element)
    false
  end
  
  def update
  end
  
  def change_position
    nil
  end
end