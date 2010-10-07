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
      "In Ruby, every thing is an object (notice I did not say 'everything'). All objects can be asked to perform an action. This is accomplished by sending an object a message. If we have an object called 'object', we can ask it to do something awesome like so:",
      "    object.do_something_awesome",
      "Try asking the object to perform.",
      "Variables given: object"
    ],
    :args => {
      :object => Class.new do
        attr_reader :success
        def perform
          @success = true
        end
      end.new
    },
    :assert => proc { |result, object| object.success }
  }
  
  @problems << {
    :clue => [
      "In this problem, you are given the door.  To proceed, simply use your new found knowledge to tell it to open.",
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