module Morf
  module Experiments
    module GameOfLife
      class Brain
        def next_state(current_state, live_neighbors_count)
          if live_neighbors_count == 3 || (current_state == 1 && live_neighbors_count == 2)
            1
          else
            0
          end
        end
      end
    end
  end
end
