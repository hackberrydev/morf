# frozen_string_literal: true

require "morf/neat/genome"
require "morf/neat/reproduction/base"

module Morf
  module NEAT
    module Reproduction
      # Crossover reproduction strategy.
      # Combines two parent genomes using NEAT crossover rules:
      # - Matching genes are randomly selected from either parent
      # - Disjoint and excess genes are inherited from the fitter parent
      class Crossover < Base
        # Combine two parent genomes using crossover.
        #
        # @param parent1 [Genome] First parent genome
        # @param parent2 [Genome] Second parent genome
        # @return [Genome] The offspring genome
        def reproduce(parent1, parent2)
          fitness1 = parent1.fitness
          fitness2 = parent2.fitness

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
      end
    end
  end
end
