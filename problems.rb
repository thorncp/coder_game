class Problems
  @problems = []
  
  # for the assert proc, the values passed in will always be the result of
  # evaling the text, followed by the args that were passed in
  
  @problems << {
    :clue => [
      "Math is awesome. In order to progress, you must master the basics.",
      "You will be given two variables, x and y. You must provide the equation that calculates the sum of these values to open the door.",
      "Variables given: x, y"
    ],
    :args => {
      :x => 133423,
      :y => 3452345
    },
    :assert => proc { |result| result == 3585768 }
  }
  
  @problems << {
    :clue => [
      "In this problem, you are given the door.  To proceed, simply open it.",
      "Variables given: door"
    ],
    :args => {
      :door => Class.new do
        attr_reader :success
        def open
          @success = true
        end
      end.new
    },
    :assert => proc { |result, door| door.success }
  }
  
  def self.next
    @problems.first
  end
  
  solve = proc { @problems.shift }
  
  @problems.each do |problem|
    problem[:clue] << "(Press esc to submit your answer)"
    problem.define_singleton_method :solved do
      solve.call
    end
  end
end