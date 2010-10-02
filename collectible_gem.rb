class CollectibleGem < Tile
  passable
  
  def initialize(window, tile_images)
    @image = tile_images[:gem]
  end
  
  def draw(x, y, z)
    # Draw, slowly rotating
    @image.draw_rot(x + 25, y + 25, z, 25 * Math.sin(Gosu::milliseconds / 133.7))
  end
end