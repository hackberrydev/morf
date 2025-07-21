# frozen_string_literal: true

module Morf
  module Experiments
    module GameOfLife
      # The Seed class determines the initial state of cells in the Game of Life.
      class Seed
        # Returns the initial state for a given cell.
        #
        # @return [Integer] The initial state of the cell (1 for alive, 0 for dead).
        def state_for(row:, column:)
          (rand < 0.3) ? 1 : 0
        end

        # Returns the default state for out-of-bounds cells.
        #
        # @return [Integer] The default state (0 for dead).
        def default_state
          0
        end
      end
    end
  end
end
