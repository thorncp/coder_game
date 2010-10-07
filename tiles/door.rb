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
  
  def hittable?
    locked?
  end
  
  def action(actor)
    @window.play(:keyboard)
    
    problem = Problems.next
    
    # that sounds backwards, but what we're doing is opening if we fail to retrieve a problem
    open unless problem
    
    if locked?
      @window.popup(problem[:clue], "# Hack the door!") do |value|
        args = problem[:args].keys
        values = problem[:args].values
        
        begin
          p = eval "proc { |#{args.join(",")}| eval(value) }"
          result = p.call(*values)
          passed = problem[:assert].call(result, *values)
        rescue Exception
          passed = false
        end
        
        if passed
          open
          problem.solved 
        end
      end
    end
  end
  
  def open
    @window.play(:door_open)
    @locked = false
  end
end