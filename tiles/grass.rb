class Grass < Tile
  hittable
  
  def initialize(window, tile_images)
    @image = tile_images[:grass]
  end
  
  def draw(x, y, z)
    @image.draw(x, y, z)
  end
end