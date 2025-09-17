# frozen_string_literal: true

module Morf
  module Experiments
    module NEAT
      # TODO: Review if these constants should be refactored. Some of these
      # values should maybe not be constants. Also, maybe they should be
      # grouped differently.
      module Constants
        INDEPENDENT_RUNS = 1
        POPULATION_SIZE = 200
        GENERATIONS = 100
        ELITISM_DEGREE = 1

        GRID_SIZE = 6
        DEVELOPMENT_ITERATIONS = 30

        COLOR_MAP = {0 => :black, 1 => :blue, 2 => :white, 3 => :red}.freeze

        FRENCH_FLAG_PATTERN = [
          [1, 1, 2, 2, 3, 3],
          [1, 1, 2, 2, 3, 3],
          [1, 1, 2, 2, 3, 3],
          [1, 1, 2, 2, 3, 3],
          [1, 1, 2, 2, 3, 3],
          [1, 1, 2, 2, 3, 3]
        ].freeze

        SEED_PATTERN = [
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 2, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0]
        ].freeze

        # CPPN Configuration
        CPPN_INPUTS = 8 # Moore neighborhood
        CPPN_OUTPUTS = 4 # dead, blue, white, red
      end
    end
  end
end
