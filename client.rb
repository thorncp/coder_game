class Client < Player
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
    false
  end
end