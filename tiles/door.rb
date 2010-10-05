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
    clue = [
      "Math is awesome. In order to progress, you must master the basics.",
      "You will be given two variables, x and y. You must provide the sum of these values open the door."
    ]
    if locked?
      @window.popup(clue, "# Hack the door!") do |value|
        test = proc { |x, y| eval(value) }.call(5, 7)
        @locked = false if test == 12
      end
    end
  end
end