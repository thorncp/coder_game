require "yaml"

class Door < Tile
  def initialize(window, tile_images)
    @window = window
    @locked = true
    @locked_image = tile_images[:locked_door]
    @unlocked_image = tile_images[:unlocked_door]
  end
  
  def draw(x, y, z)
    image = locked? ? @locked_image : @unlocked_image
    image.draw(x, y, z)
  end
  
  def locked?
    @locked
  end
  
  def passable?
    not locked?
  end
  
  def action(actor)
    stuff = YAML.load_file("problems.yml")
    
    h = stuff.sample
    
    if locked?
      @window.popup(h[:clue], "# Hack the door!") do |value|
        passed = h[:tests].all? do |test|
          args = test[:args].keys
          values = test[:args].values
          result = eval "proc { |#{args.join(",")}| eval(value) }.call(#{values.join(",")})"
          result == test[:result]
        end
        @locked = false if passed
      end
    end
  end
end