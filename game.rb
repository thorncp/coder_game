class Game < Gosu::Window
  attr_reader :map

  def initialize
    @resolution_x = 640
    @resolution_y = 480
    super(@resolution_x, @resolution_y, false)
    self.caption = "Cptn. Ruby"
    @sky = Gosu::Image.new(self, "media/Space.png", true)
    @map = Map.new(self, "media/CptnRuby Map.txt")
    @player = Player.new(self, 400, 100)
    # The scrolling position is stored as top left corner of the screen.
    @camera_x = @camera_y = 0
  end
  
  def update
    move_x = 0
    move_x -= 5 if button_down? Gosu::KbLeft
    move_x += 5 if button_down? Gosu::KbRight
    
    @player.update(move_x)
    
    # Scrolling follows player
    @camera_x = [[@player.x - @resolution_x / 2, 0].max, @map.width * 50 - @resolution_x].min
    @camera_y = [[@player.y - @resolution_y / 2, 0].max, @map.height * 50 - @resolution_y].min
  end
  
  def draw
    @sky.draw 0, 0, 0
    translate(-@camera_x, -@camera_y) do
      @map.draw
      @player.draw
    end
  end
  
  def button_down(id)
    case id
      when Gosu::KbEscape then close
      when Gosu::KbUp then @player.jump
    end
  end
end