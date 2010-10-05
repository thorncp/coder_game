class Game < Gosu::Window
  attr_reader :map, :resolution_x, :resolution_y

  def initialize
    @resolution_x = 640
    @resolution_y = 480
    super(@resolution_x, @resolution_y, false)
    self.caption = "Code or Die: The Uncoded One"
    @sky = Gosu::Image.new(self, "media/Space.png", true)
    @map = Map.new(self, "media/CptnRuby Map.txt")
    @player = Player.new(self, @map.start_position[:x], @map.start_position[:y])
    # The scrolling position is stored as top left corner of the screen.
    @camera_x, @camera_y = 0, 10
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @game_over_font = Gosu::Font.new(self, Gosu::default_font_name, 72)
  end
  
  def update
    if @player.health > 0
      move_x = 0
      move_x -= 5 if button_down? Gosu::KbLeft
      move_x += 5 if button_down? Gosu::KbRight
    
      @player.update(move_x)
    
      # Scrolling follows player
      @camera_x = [[@player.x - @resolution_x / 2, 0].max, @map.width * 50 - @resolution_x].min
    
      @map.update(@player)
    else
      @game_over = true
    end
  end
  
  def draw
    @sky.draw 0, 0, 0
    translate(-@camera_x, -@camera_y) do
      @map.draw(@player.x)
      @player.draw
    end
    @font.draw("Health: #{@player.health}", 10, 10, 0, 1.0, 1.0, 0xffffff00)
    
    if @game_over
      @game_over_font.draw("Game Over", @resolution_x / 5, @resolution_y / 3, 0, 1.0, 1.0, 0xffff0000)
    end
  end
  
  def button_down(id)
    case id
      when Gosu::KbEscape then close
      when Gosu::KbUp then @player.jump
      when Gosu::KbF then action
      when Gosu::KbSpace then @player.fire
    end
  end
  
  def action
    @map.action(@player)
  end
end