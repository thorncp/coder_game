class Doc < Projectile
  attr_reader :x, :y, :dir, :velocity_x, :power
  
  def initialize(image, x, y, dir, owner)
    @image = image
    @x = x
    @y = y
    @dir = dir
    @velocity_x = dir == :left ? -7 : 7
    @power = 1
    @owner = owner
  end
  
  def draw
    @x += @velocity_x
    @image.draw(@x - 10, @y - 50, 0)
  end
  
  def next_x
    @x + @velocity_x
  end
end