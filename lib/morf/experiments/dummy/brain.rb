module Morf
  module Experiments
    module Dummy
      class Brain
        def next_state(state, neighbourhood)
          neighbourhood.sum
        end
      end
    end
  end
end
