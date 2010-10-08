class Thought
  class << self
    attr_reader :thoughts
  end
  
  @thoughts = [
    "Man, if I were designing a game about this craziness right now, I'd totally make the F key perform actions.",
    "WTF is this door? Looks to be locked. Maybe I can hack it.",
    "Well that wasn't too bad. What worries me though is that door wasn't here last night...",
    "Who designed this security? I could have seriously broken through this place my freshman year. Gahh, I can't think straight though. I'm really going to have to clear my head to tackle another door. What the hell are they protecting anyway? There's nothing here but smooth stone and corkboard.",
    "Hmm. That's a long drop, but I don't see another way.  What the hell, my entire body is numb anyway...",
    "I hear someone down the hall. Did he seriously just say 'TPS Report'? There doesn't seem to be enough SPACE to get around him unnoticed. This is one intern that's about to raise the BAR.",
    "HOLY CRAP. I just projected raw code from my mind. MY MIND! What the hell is this place and WTF did they do to me!? I'm also quite sure I can hear the sounds of a number incrementing."
  ]
  
  attr_reader :x, :y
  
  def initialize(x, y)
    @x = x
    @y = y
  end

  def text
    self.class.thoughts.shift
  end
end