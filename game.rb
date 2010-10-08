class Game < Gosu::Window
  attr_reader :map, :resolution_x, :resolution_y

  def initialize
    @resolution_x = 640
    @resolution_y = 480
    super(@resolution_x, @resolution_y, false)

    self.caption = "Code or Die: The Last Encoding: The Uncoded One"
    @sky = Gosu::Image.new(self, "media/Wallpaper.png", true)
    @map = Map.new(self, "media/CptnRuby Map.txt")
    @player = Player.new(self, @map.start_position[:x], @map.start_position[:y])
    # The scrolling position is stored as top left corner of the screen.
    @camera_x, @camera_y = 0, 10
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @game_over_font = Gosu::Font.new(self, Gosu::default_font_name, 72)
    @cursor = Gosu::Image.new(self, "media/Cursor.png", false)
    
    @messages = []
    
    @audio = {}
    
    # credit: http://soundbible.com/1273-Metal-Reflect.html
    @audio[:keyboard] = Gosu::Sample.new(self, "audio/ui_click.mp3")
    
    # credit: http://soundbible.com/1104-Metal-Clank-Wobble.html
    @audio[:door_open] = Gosu::Sample.new(self, "audio/door_open.mp3")
    
    # credit: http://soundbible.com/1087-Laser.html
    @audio[:code] = Gosu::Sample.new(self, "audio/code.mp3")
    
    # credit: http://soundbible.com/1033-Zombie-In-Pain.html
    @audio[:death] = Gosu::Sample.new(self, "audio/death.mp3")
    
    # credit: http://soundbible.com/214-Tearing-Paper.html
    @audio[:doc] = Gosu::Sample.new(self, "audio/doc.mp3")
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
      y = 20
      @summaries.each { |s| @font.draw(s, 50, y += 25, 0, 1.0, 1.0, 0xffffffff) }
      @popup.draw
      @cursor.draw(mouse_x, mouse_y, 0)
      return
    end
    
    @sky.draw 0, 0, 0
    translate(-@camera_x, -@camera_y) do
      @map.draw(@player.x)
      @player.draw
    end
    @font.draw("Health: #{@player.health}", 10, 4, 0, 1.0, 1.0, 0xffffff00)
    @font.draw("Mind Power: #{@player.mind_power}", 10, 22, 0, 1.0, 1.0, 0xffffff00)
    
    y = 40
    @messages.reject! do |message, i|
      blah = Gosu::milliseconds - i
      color = Gosu::Color::YELLOW
      color.alpha = [(255 - blah / 2000.0 * 255).to_i, 0].max

      @font.draw(message, width/3, y, 0, 1.0, 1.0, color)
      y += 20
      blah > 1800
    end
    
    if @game_over
      @game_over_font.draw("Game Over", @resolution_x / 5, @resolution_y / 3, 0, 1.0, 1.0, 0xffff0000)
    end
  end
  
  def make_sure_output_is_koshure(arr)
    [*arr].each_with_index.map do |message, index|
      message.size > 50 ? split_string(message, 50) : arr[index]
    end.flatten
  end
  
  def split_string(str, length)
    str.split(" ").inject([""]) do |arr, word|
      arr.push("") if arr.last.size > length
      arr.last << "#{word} "
      arr
    end.map(&:strip)
  end
  
  def popup(summary, text, &block)
    @summaries = make_sure_output_is_koshure(summary)
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
  
  def play(sound)
    @audio[sound].play
  end
  
  def message(msg)
    @messages << [msg, Gosu::milliseconds]
  end
end