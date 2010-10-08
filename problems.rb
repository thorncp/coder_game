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
      "In this problem, you are given the door. To proceed, simply use your new found knowledge to tell it to open.",
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
  
  @problems << {
    :clue => [
      "Often times you will need to store collections of data. Ruby provides Arrays and Hashes for this (there are many more, but these are by far the most used).",
      "To create an array, we use square brackets, [ and ]. If we have a set of strings we want in an array, we can do:",
      '    my_array = ["oh snap", "storing data", "and stuff"]',
      "Arrays don't have to contain all of the same type of data either.  Try creating an array containing different types, like strings and numbers.",
      "Variables given: (none)"
    ],
    :args => {
    },
    :assert => proc { |result| result.map(&:class).uniq.size > 1 }
  }
  
  @problems << {
    :clue => [
      "Ruby has very powerful ways of traversing and manipulating collections of data. For example, if we have an Array of Clients, and we want to tell each of them to go to hell, we'd do:",
      "clients.each { |client| client.go_to_hell }",
      "Why don't you try it, except tell them to go wherever you want.",
      "Variables given: clients"
    ],
    :args => {
      :clients => [
        Class.new do
          attr_reader :success
          def method_missing(sym, &block)
            @success = true if sym =~ /go_to_.*/
          end
        end.new,
        Class.new do
          attr_reader :success
          def method_missing(sym, &block)
            @success = true if sym =~ /go_to_.*/
          end
        end.new
      ]
    },
    :assert => proc { |result, clients| clients.all? &:success }
  }

  @problems << {
    :clue => [
      "Have a freebie (just hit escape)",
      "Variables given: none"
    ],
    :args => {
    },
    :assert => proc { true }
  }

  @problems << {
    :clue => [
      "Have another freebie (just hit escape)",
      "Variables given: none"
    ],
    :args => {
    },
    :assert => proc { true }
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