# frozen_string_literal: true

require "morf/neat/reproduction/base"

module Morf
  module NEAT
    module Reproduction
      # Duel reproduction strategy.
      # Two genomes compete based on fitness - the one with higher fitness
      # has a higher probability of being selected.
      # Returns a clone of the selected parent.
      class Duel < Base
        # Select one parent based on fitness-weighted probability.
        #
        # @param parent1 [Genome] First parent genome
        # @param parent2 [Genome] Second parent genome
        # @return [Genome] Clone of the selected parent
        def reproduce(parent1, parent2)
          fitness1 = parent1.fitness
          fitness2 = parent2.fitness

          # Calculate selection probabilities based on relative fitness
          total_fitness = fitness1 + fitness2
          prob_parent1 = fitness1 / total_fitness

          # Select parent based on probability
          selected_parent = if @random.rand < prob_parent1
            parent1
          else
            parent2
          end

          selected_parent.clone
        end
      end
    end
  end
end
