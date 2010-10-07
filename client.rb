class Client < Player
  def initialize(window, x, y)
    super
    @config[:jump_strength] = 10
  end
  
  def update
    thing = Gosu::milliseconds % 10000
    
    case thing
      when 0..3000
        move(-1, 0)
      when 5000..8000
        move(1, 0)
    end
    
    jump if (2800..3000).include? Gosu::milliseconds % 3000
    fire if (0..20).include? Gosu::milliseconds % 2000
    
    fall
    select_image
  end
end