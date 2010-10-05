class Desk < Tile
	passable
  def initialize(window, tile_images)
    @image = tile_images[:desk]
  end
  
  def draw(x, y, z)
    @image.draw(x, y, z)
  end
  
end