# frozen_string_literal: true

require "morf/neat/genome"

module Morf
  module NEAT
    class Reproduction
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
            child_connection_genes << [conn1, conn2].sample(random: @random)
            i += 1
            j += 1
          elsif conn1.innovation_number < conn2.innovation_number
            child_connection_genes << conn1 if fitness1 >= fitness2
            i += 1
          else
            child_connection_genes << conn2 if fitness2 >= fitness1
            j += 1
          end
        end

        while i < parent1_connections.size
          child_connection_genes << parent1_connections[i] if fitness1 >= fitness2
          i += 1
        end

        while j < parent2_connections.size
          child_connection_genes << parent2_connections[j] if fitness2 >= fitness1
          j += 1
        end

        Morf::NEAT::Genome.new(
          node_genes: parent1.node_genes,
          connection_genes: child_connection_genes
        )
      end
    end
  end
end
