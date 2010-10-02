class Player
  attr_reader :x, :y
  
  ImageFileName = "media/CptnRuby.png"
  ImageSize = 50
  BobbleInterval = 200

  def initialize(window, x, y)
    @x, @y = x, y
    @dir = :left
    
    @map = window.map
    
    # Load all animation frames
    images = Gosu::Image.load_tiles(window, ImageFileName, ImageSize, ImageSize, false)
    @images = Hash[[:standing, :bobble1, :bobble2, :jump].zip(images)]
    
    # This always points to the frame that is currently drawn.
    # This is set in update, and used in draw.
    @cur_image = @images[:standing]
  end
  
  def draw
    if @dir == :left
      offs_x = -ImageSize / 2
      factor = 1.0
    else
      offs_x = ImageSize / 2
      factor = -1.0
    end
    
    @cur_image.draw(@x + offs_x, @y - ImageSize - 1, 0, factor, 1.0)
  end
  
  def update(delta_x)
    @moving = false
    
    unless delta_x.zero?
      # determine which direction we're facing
      @dir = delta_x > 0 ? :right : :left
      
      # make the move
      move delta_x, 0
    end
    
    if moving?
      # bobble the sprite
      @cur_image = bobble? ? @images[:bobble1] : @images[:bobble2]
    else
      # stand still
      @cur_image = @images[:standing]
    end
  end
  
  def moving?
    @moving
  end
  
  def bobble?
    (Gosu::milliseconds / BobbleInterval).even?
  end
  
  def move(delta_x = 0, delta_y = 0)
    unless @map.solid?(@x + delta_x, @y + delta_y)
      @x += delta_x
      @y += delta_y
      @moving ||= true
    end
  end
end