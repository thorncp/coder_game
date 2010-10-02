class Code < Projectile
  attr_reader :x, :y, :dir, :velocity_x
  
  def initialize(image, x, y, dir)
    @image = image
    @x = x
    @y = y
    @dir = dir
    @velocity_x = dir == :left ? -10 : 10
  end
  
  def draw
    @x += @velocity_x
    @image.draw(@x - 10, @y - 50, 0)
  end
  
  def next_x
    @x + @velocity_x
  end
end