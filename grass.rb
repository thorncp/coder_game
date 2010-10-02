class Grass < Resource
  def initialize(window, resources)
    @image = resources[:grass]
  end
  
  def draw(x, y, z)
    @image.draw(x, y, z)
  end
end