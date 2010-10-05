class Door < Tile
  def initialize(window, tile_images)
    @window = window
    @locked = true
    @locked_image = tile_images[:locked_door]
    @unlocked_image = tile_images[:unlocked_door]
  end
  
  def draw(x, y, z)
    image = locked? ? @locked_image : @unlocked_image
    image.draw(x, y, z)
  end
  
  def locked?
    @locked
  end
  
  def passable?
    not locked?
  end
  
  def action(actor)
    if locked?
      @window.popup("# Hack the door!") do |value|
        @locked = false if value == "haxor"
      end
    end
  end
end