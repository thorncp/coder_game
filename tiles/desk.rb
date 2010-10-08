class Desk < Tile
	passable
	
	Items = {
	  :coffee => {
	    :message => "You found coffee!",
	    :action => proc { |player| player.add_mind_power(5) }
	  },
	  :chips => {
	    :message => "You found chips, NOM NOM!",
	    :action => proc { |player| player.add_health(3) }
	  },
	  :nothing => {
	    :message => "You found nothing :(",
	    :action => proc {}
	  }
	}
	
  def initialize(window, tile_images)
    @window = window
    @image = tile_images[:desk]
    @searched = false
  end
  
  def draw(x, y, z)
    @image.draw(x, y, z)
  end
  
  def action(actor)
    return if @searched
    @searched = true
    @window.play(:desk)
    
    if actor.health >= 5 and actor.mind_power >= 10
      item = Items[:nothing]
    elsif actor.health < 5
      item = Items[:chips]
    else
      item = Items[:coffee]
    end
    
    @window.message(item[:message])
    item[:action].call(actor)
  end
end