class Player
  attr_reader :x, :y

  def initialize(window, x, y)
    @size = 50
    @x, @y = x, y
    @dir = :left
    @vy = 0 # Vertical velocity
    @map = window.map
    # Load all animation frames
    @standing, @walk1, @walk2, @jump =
      *Gosu::Image.load_tiles(window, "media/CptnRuby.png", @size, @size, false)
    # This always points to the frame that is currently drawn.
    # This is set in update, and used in draw.
    @cur_image = @standing    
  end
  
  def draw
    offs_x = 25
    factor = -1.0
    
    if @dir == :left
      offs_x *= -1
      factor *= -1
    end
    
    @cur_image.draw(@x + offs_x, @y - @size - 1, 0, factor, 1.0)
  end
  
  def update(move_x)
    
  end
end