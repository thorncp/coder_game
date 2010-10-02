class Map
  attr_reader :width, :height, :gems, :start_position
  
  def initialize(window, filename)
    @window = window
    
    # Load 60x60 tiles, 5px overlap in all four directions.
    @tileset = Gosu::Image.load_tiles(window, "media/CptnRuby Tileset.png", 60, 60, true)

    gem_img = Gosu::Image.new(window, "media/CptnRuby Gem.png", false)
    @gems = []

    lines = File.readlines(filename).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
        when '"'
          Tiles::Grass
        when '#'
          Tiles::Earth
        when 'x'
          @gems.push(CollectibleGem.new(gem_img, x * 50 + 25, y * 50 + 25))
          nil
        when 'p'
          @start_position = {:x => x, :y => y}
          nil
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
          @tileset[tile].draw(x * 50 - 5, y * 50 - 5, 0)
        end
      end
    end
    
    hil = left * 50 + 25
    hir = right * 50 + 25
    
    @gems.select{ |g| (hil..hir).include? g.x }.each { |c| c.draw }
  end
  
  # Solid at a given pixel position?
  def solid?(x, y)
    y < 0 || @tiles[x / 50][y / 50]
  end
end