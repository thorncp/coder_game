class Thought
  class << self
    attr_reader :thoughts
  end
  
  @thoughts = [
    "WTF is this door? Looks to be locked. Maybe I can hack it.",
    "Well that wasn't too bad. What worries me though is that door wasn't here last night..."
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