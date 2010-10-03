class Client < Player
  JumpStrength = 8
  
  def update
    thing = Gosu::milliseconds % 12000
    
    case thing
      when 0..4000
        move(-1, 0)
      when 6000..10000
        move(1, 0)
    end
    
    fall
    select_image
  end
  
  def draw(x, y, z)
    if @dir == :left
      offs_x = -ImageSize / 2
      factor = 1.0
    else
      offs_x = ImageSize / 2
      factor = -1.0
    end
    
    @cur_image.draw(@x + offs_x, @y - ImageSize - 1, z, factor, 1.0)
  end
  
  def passable?
    true
  end
  
  def change_position
    [@x, @y]
  end
end