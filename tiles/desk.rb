class Desk < Tile
	passable
	
	Items = {
	  :coffee => {
	    :message => "You found coffee!",
	    :action => proc { |player| player.add_mind_power(3) }
	  },
	  :chips => {
	    :message => "You found chips, NOM NOM!",
	    :action => proc { |player| player.add_health(3) }
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
    item = Items[Items.keys.sample]
    @window.message(item[:message])
    item[:action].call(actor)
  end
end