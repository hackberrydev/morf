# frozen_string_literal: true

module Morf
  module Experiments
    module NEAT
      class Seed
        def initialize(seed_pattern)
          @seed_pattern = seed_pattern
        end

        def state_for(row:, column:)
          @seed_pattern[row][column]
        end

        def default_state
          0 # Black/dead
        end
      end
    end
  end
end
