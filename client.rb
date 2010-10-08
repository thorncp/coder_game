class Client < Player
  def initialize(window, x, y)
    super
    @config[:jump_strength] = 10
    @health = 3
  end
  
  # you know things are like spaghetti when the param to the overridden class
  # is gonna be completely different than the base class
  def update(player)
    @dir = player.x < @x ? :left : :right
    thing = Gosu::milliseconds % 10000
    
    case thing
      when 0..3000
        move(-1, 0)
      when 5000..8000
        move(1, 0)
    end
    
    if (player.y / 50 - @y / 50).abs < 2
      jump if (1800..2000).include? Gosu::milliseconds % 2000
      fire if (0..20).include? Gosu::milliseconds % 1000
    end
    
    fall
    select_image
  end
  
  def fire
    if Gosu::milliseconds - @last_fired >= FireCoolDown
      @window.play(:doc)
      @window.map.fire(:doc, @x, @y, @dir, self)
      @last_fired = Gosu::milliseconds
    end
  end
end