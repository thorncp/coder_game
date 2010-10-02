class Door < Resource
  def initialize(window, resources)
    @locked = true
    @locked_image = resources[:locked_door]
    @unlocked_image = resources[:unlocked_door]
  end
  
  def draw(x, y, z)
    @locked = (Gosu::milliseconds / 5000).even?
    image = locked? ? @locked_image : @unlocked_image
    image.draw(x, y, z)
  end
  
  def locked?
    @locked
  end
  
  def passable?
    not locked?
  end
end