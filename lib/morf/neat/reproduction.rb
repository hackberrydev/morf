# frozen_string_literal: true

require "morf/neat/genome"

module Morf
  module NEAT
    class Reproduction
      # @param random [Random] The random number generator.
      def initialize(random: Random)
        @random = random
      end

      def crossover(parent1, parent2, fitness1, fitness2)
        child_connection_genes = []
        parent1_connections = parent1.connection_genes.sort_by(&:innovation_number)
        parent2_connections = parent2.connection_genes.sort_by(&:innovation_number)

        i = 0
        j = 0

        while i < parent1_connections.size && j < parent2_connections.size
          conn1 = parent1_connections[i]
          conn2 = parent2_connections[j]

          if conn1.innovation_number == conn2.innovation_number
            child_connection_genes << [conn1, conn2].sample(random: @random).clone
            i += 1
            j += 1
          elsif conn1.innovation_number < conn2.innovation_number
            child_connection_genes << conn1.clone if fitness1 >= fitness2
            i += 1
          else
            child_connection_genes << conn2.clone if fitness2 >= fitness1
            j += 1
          end
        end

        while i < parent1_connections.size
          child_connection_genes << parent1_connections[i].clone if fitness1 >= fitness2
          i += 1
        end

        while j < parent2_connections.size
          child_connection_genes << parent2_connections[j].clone if fitness2 >= fitness1
          j += 1
        end

        node_genes = (parent1.node_genes + parent2.node_genes).uniq(&:id)

        Morf::NEAT::Genome.new(
          node_genes: node_genes.map(&:clone),
          connection_genes: child_connection_genes
        )
      end

      # Two genomes duel - the one with higher fitness has a higher chance of winning.
      # Returns a clone of the winner.
      #
      # @param parent1 [Genome] First parent candidate
      # @param parent2 [Genome] Second parent candidate
      # @return [Genome] Clone of the winner
      def duel(parent1, parent2)
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
