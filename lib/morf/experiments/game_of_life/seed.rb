# frozen_string_literal: true

module Morf
  module Experiments
    module GameOfLife
      class Seed
        def state_for(row:, column:)
          0
        end

        def default_state
          0
        end
      end
    end
  end
end
