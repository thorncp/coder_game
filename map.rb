class Map
  attr_reader :width, :height, :gems, :start_position
  
  def initialize(window, filename)
    @window = window
    
    ground = Gosu::Image.load_tiles(window, "media/CptnRuby Tileset.png", 60, 60, true)
    @tile_images = {}
    @tile_images[:grass] = Gosu::Image.new(window, "media/Tile.png", false)
    @tile_images[:dirt] = Gosu::Image.new(window, "media/Tile.png", false)
    @tile_images[:locked_door] = Gosu::Image.new(window, "media/locked_door.png", false)
    @tile_images[:unlocked_door] = Gosu::Image.new(window, "media/unlocked_door.png", false)
    @tile_images[:gem] = Gosu::Image.new(window, "media/CptnRuby Gem.png", false)
    @tile_images[:desk] = Gosu::Image.new(window, "media/desk.png", false)
    
    @projectile_assets = Hash.new { |h,k| h[k] = {} }
    @projectile_assets[:code][:class] = Code
    @projectile_assets[:code][:image] = Gosu::Image.new(window, "media/code.png", false)
    @projectile_assets[:doc][:class] = Doc
    @projectile_assets[:doc][:image] = Gosu::Image.new(window, "media/doc.png", false)
    
    @projectiles = []
    @clients = []
    @thoughts = []
    
    lines = File.readlines(filename).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
        when '"'
          Grass.new(@window, @tile_images)
        when '#'
          Dirt.new(@window, @tile_images)
        when 'x'
          CollectibleGem.new(@window, @tile_images)
        when 'p'
          @start_position = {:x => x, :y => y}
          nil
        when "l"
          Door.new(@window, @tile_images)
        when "c"
          @clients << Client.new(@window, x, y)
          nil
        when 'd'
          Desk.new(@window, @tile_images)
        when 't'
          @thoughts << Thought.new(x, y)
          nil
        when 'e'
          @end_position = {:x => x, :y => y}
          nil
        else
          nil
        end
      end
    end
    
    @block_width = @window.width / @width
  end
  
  def update(player)
    if player.x / 50 == @end_position[:x] and player.y / 50 == @end_position[:y]
      @window.dialog(["Congratulations, you escaped!","","You have a final score of #{player.score}"])
      @end_position[:x] = @end_position[:y] = nil
      @window.win
    end
    
    @thoughts.reject! do |t|
      if player.x / 50 == t.x and player.y / 50 == t.y
        @window.dialog(t.text)
        true
      end
    end
    
    @left = [[player.x / 50 - @block_width / 2 - 2, 0].max, @width - @block_width - 2].min
    @right = [@left + @block_width + 4, @width - 1].min
    
    @left.upto(@right) do |x|
      @height.times do |y|
        tile = @tiles[x][y]
        if tile
          tile.update
          if moved = tile.change_position
            new_x, new_y = moved[0] / 50, moved[1] / 50
            unless x == new_x and y == new_y
              @tiles[x][y] = nil
              @tiles[new_x][new_y] = tile
            end
          end
        end
      end
    end
    
    @clients.each do |client|
      if (@left..@right).include? client.x / 50
        client.update(player)
      end
    end
    
    @projectiles.reject! do |p|
      projectile_hit?(p, player)
    end
  end
  
  def projectile_hit?(p, player)
    x, y = p.next_x, p.y - 25
    # holy crap this is out of control
    # but it works for now
    
    # first see if the player is hit
    tile = player if p.owner != player and (x - player.x).abs < 20 and (y - player.y).abs < 35
    if tile and tile != p.owner
      tile.hit(p)
      return true
    end
    
    # now see if we can hit a client
    tile = @clients.find { |c| (x - c.x).abs < 20 and (y + 10 - c.y).abs < 25 }
    if tile and tile != p.owner
      @clients.delete(tile) and player.increase_score(5) if tile.hit(p)
      return true
    end
    
    # finally see if we hit the environment
    tile = tile_at(x, y)
    if tile and tile.hittable?
      remove_tile(x, y) if tile.hit(p)
      return true
    end
  end
  
  def draw(x)
    @left.upto(@right) do |x|
      @height.times do |y|
        tile = @tiles[x][y]
        if tile
          # Draw the tile with an offset (tile images have some overlap)
          # Scrolling is implemented here just as in the game objects.
          tile.draw(x * 50 - 5, y * 50 - 5, 0)
        end
      end
    end
    
    @clients.each do |client|
      if (@left..@right).include? client.x / 50
        client.draw
      end
    end
    
    @projectiles.reject! do |p|
      if (@left..@right).include?(p.x / 50)
        p.draw
        false
      else
        true
      end
    end
  end
  
  def action(element)
    offset = element.dir == :left ? 25 : -25
    
    x, y = (element.x + offset) / 50, (element.y - 25) / 50
    
    x += element.dir == :left ? -1 : 1
    
    @tiles[x][y].action(element) if @tiles[x][y]
  end
  
  def fire(element, x, y, dir, owner)
    projectile = @projectile_assets[element]
    @projectiles << projectile[:class].new(projectile[:image], x, y, dir, owner)
  end
  
  # Solid at a given pixel position?
  def solid?(x, y)
    tile = @tiles[x / 50][y / 50]
    y < 0 || tile && !tile.passable?
  end
  
  def remove_tile(x, y)
    @tiles[x / 50][y / 50] = nil
  end
  
  def tile_at(x, y)
    @tiles[x / 50][y / 50]
  end
end