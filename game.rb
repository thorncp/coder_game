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
    @cursor = Gosu::Image.new(self, "media/Cursor.png", false)
  end
  
  def update
    @game_over = true and return if @player.health <= 0
    
    move_x = 0
    move_x -= 5 if button_down? Gosu::KbLeft
    move_x += 5 if button_down? Gosu::KbRight
  
    @player.update(move_x)
  
    # Scrolling follows player
    @camera_x = [[@player.x - @resolution_x / 2, 0].max, @map.width * 50 - @resolution_x].min
  
    @map.update(@player)
  end
  
  def draw
    if @popup
      @popup.draw
      @cursor.draw(mouse_x, mouse_y, 0)
      return
    end
    
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
  
  def popup(text, &block)
    @popup = Popup.new(self, @font, text, &block)
    self.text_input = @popup
  end
  
  def button_down(id)
    case id
      when Gosu::KbEscape
        if @popup
          close_popup
        else
          close
        end
      when Gosu::KbUp then @player.jump
      when Gosu::KbF then action
      when Gosu::KbSpace then @player.fire
    end
  end
  
  def close_popup
    @popup.close
    @popup = nil
    self.text_input = nil
  end
  
  def action
    @map.action(@player)
  end
end