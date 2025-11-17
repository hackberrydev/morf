# frozen_string_literal: true

module Morf
  module NEAT
    module Reproduction
      # Base class for reproduction strategies.
      # All reproduction strategies must implement the `reproduce` method.
      class Base
        # @param random [Random] The random number generator.
        def initialize(random: Random)
          @random = random
        end

        # Combine two parent genomes to produce an offspring.
        #
        # @param parent1 [Genome] First parent genome
        # @param parent2 [Genome] Second parent genome
        # @return [Genome] The offspring genome
        def reproduce(parent1, parent2)
          raise NotImplementedError, "Subclasses must implement #reproduce"
        end
      end
    end
  end
end
