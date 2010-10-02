class Dirt < Resource
  def initialize(window, resources)
    @image = resources[:dirt]
  end
  
  def draw(x, y, z)
    @image.draw(x, y, z)
  end
end