class Dirt < Tile
  def initialize(window, tile_images)
    @image = tile_images[:dirt]
  end
  
  def draw(x, y, z)
    @image.draw(x, y, z)
  end
end