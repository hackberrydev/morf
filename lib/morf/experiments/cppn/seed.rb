# frozen_string_literal: true

module Morf
  module Experiments
    module Cppn
      # The Seed class determines the initial state of cells in the CPPN experiment.
      class Seed
        # Returns the initial state for a given cell.
        #
        # @return [Integer] The initial state of the cell (0, 1, 2, or 3).
        def state_for(row:, column:)
          rand(0..3)
        end

        # Returns the default state for out-of-bounds cells.
        #
        # @return [Integer] The default state (0).
        def default_state
          0
        end
      end
    end
  end
end
