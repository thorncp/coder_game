class Map
  attr_reader :width, :height, :gems, :start_position
  
  def initialize(window, filename)
    @window = window
    
    ground = Gosu::Image.load_tiles(window, "media/CptnRuby Tileset.png", 60, 60, true)
    @resources = {}
    @resources[:grass] = ground[0]
    @resources[:dirt] = ground[1]
    @resources[:locked_door] = Gosu::Image.new(window, "media/locked_door.png", false)
    @resources[:unlocked_door] = Gosu::Image.new(window, "media/unlocked_door.png", false)
    @resources[:gem] = Gosu::Image.new(window, "media/CptnRuby Gem.png", false)
    
    lines = File.readlines(filename).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
        when '"'
          Grass.new(@window, @resources)
        when '#'
          Dirt.new(@window, @resources)
        when 'x'
          CollectibleGem.new(@window, @resources)
        when 'p'
          @start_position = {:x => x, :y => y}
          nil
        when "l"
          Door.new(@window, @resources)
        else
          nil
        end
      end
    end
    
    @block_width = @window.width / @width
  end
  
  def draw(x)
    left = [[x / 50 - @block_width / 2 - 2, 0].max, @width - @block_width - 2].min
    right = [left + @block_width + 4, @width - 1].min
    
    left.upto(right) do |x|
      @height.times do |y|
        tile = @tiles[x][y]
        if tile
          # Draw the tile with an offset (tile images have some overlap)
          # Scrolling is implemented here just as in the game objects.
          tile.draw(x * 50 - 5, y * 50 - 5, 0)
        end
      end
    end
    
    hil = left * 50 + 25
    hir = right * 50 + 25
    
    #@gems.select{ |g| (hil..hir).include? g.x }.each { |c| c.draw }
  end
  
  # Solid at a given pixel position?
  def solid?(x, y)
    tile = @tiles[x / 50][y / 50]
    y < 0 || tile && !tile.passable?
  end
end