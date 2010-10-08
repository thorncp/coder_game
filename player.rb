class Player
  attr_reader :x, :y, :dir, :health, :mind_power
  
  ImageSize = 50
  HeadRoom = 5 # this is the buffer of how high into an object the player can jump
  BobbleInterval = 200
  GravityAcceleration = 1
  FireCoolDown = 150

  def initialize(window, x, y)
    @x, @y = x * ImageSize + ImageSize / 2, y * ImageSize + (ImageSize - HeadRoom)
    @dir = :left
    @velocity_y = 0
    
    @config = {}
    @config[:jump_strength] = 14
    
    @window = window
    
    image_file = "media/#{self.class.name}.png"
    
    # Load all animation frames
    images = Gosu::Image.load_tiles(window, image_file, ImageSize, ImageSize, false)
    @images = Hash[[:standing, :bobble1, :bobble2, :jumping].zip(images)]
    
    # This always points to the frame that is currently drawn.
    # This is set in update, and used in draw.
    @cur_image = @images[:standing]
    
    @health = 3
    @last_fired = 0
    @mind_power = 0
  end
  
  def draw
    draw_image
  end
  
  def update(delta_x = 0)
    @moving = false
    
    unless delta_x.zero?
      # determine which direction we're facing
      @dir = delta_x > 0 ? :right : :left
      
      # make the move
      move delta_x, 0
    end
    
    fall
    select_image
  end
  
  def moving?
    @moving
  end
  
  def jumping?
    @velocity_y < 0
  end
  
  def bobble?
    (Gosu::milliseconds / BobbleInterval).even?
  end
  
  def move(delta_x = 0, delta_y = 0)
    if !solid?(delta_x, delta_y) or solid?(0, 0)
      @x += delta_x
      @y += delta_y
      @moving ||= true
    end
  end

  def jump
    # if there's ground under our feet, we can jump
    if solid? 0, 1
      @velocity_y = -@config[:jump_strength]
    end
  end
  
  def fall
    # rudimentary gravity
    @velocity_y += GravityAcceleration
    
    # positive means we're falling
    delta_y = @velocity_y > 0 ? 1 : -1
    
    @velocity_y.abs.times do
      solid?(0, delta_y) ? @velocity_y = 0 : move(0, delta_y)
    end
  end
  
  def solid?(delta_x, delta_y)
    @window.map.solid?(@x + delta_x, @y + delta_y) or @window.map.solid?(@x + delta_x, @y + delta_y - (ImageSize - HeadRoom))
  end
  
  def select_image
    if jumping?
      @cur_image = @images[:jumping]
    elsif moving?
      # bobble the sprite
      @cur_image = bobble? ? @images[:bobble1] : @images[:bobble2]
    else
      # stand still
      @cur_image = @images[:standing]
    end
  end
  
  def fire
    if Gosu::milliseconds - @last_fired >= FireCoolDown and @mind_power > 0
      @window.play(:code)
      @window.map.fire(:code, @x, @y, @dir, self)
      @last_fired = Gosu::milliseconds
      @mind_power -= 1
    end
  end
  
  def draw_image
    if @dir == :left
      offs_x = -ImageSize / 2
      factor = 1.0
    else
      offs_x = ImageSize / 2
      factor = -1.0
    end
    
    @cur_image.draw(@x + offs_x, @y - ImageSize - 1, 0, factor, 1.0)
  end
  
  def hit(projectile)
    @health -= projectile.power
    if @health <= 0
      @window.play(:death)
      true
    end
  end
  
  def passable?
    false
  end
  
  def add_mind_power(x)
    @mind_power = 10 if (@mind_power += x) > 10
  end
  
  def add_health(x)
    @health = 5 if (@health += x) > 5
  end
end