# frozen_string_literal: true

require "morf/neat/connection_gene"

module Morf
  module NEAT
    module Mutation
      class AddConnection
        def initialize(genome, mutation_strategy:, next_innovation_number:)
          @genome = genome
          @mutation_strategy = mutation_strategy
          @next_innovation_number = next_innovation_number
        end

        def call
          @mutation_strategy.add_connection_max_attempts.times do
            node1, node2 = @mutation_strategy.random_node_pair(@genome.node_genes)

            next if node1.id == node2.id # Prevent self-connection

            # Ensure the connection is feed-forward. If node1 is an output or
            # node2 is an input, try swapping them.
            if node1.type == :output || node2.type == :input
              node1, node2 = node2, node1
            end

            # After potential swapping, if the connection is still not
            # feed-forward, skip this attempt.
            next if node1.type == :output || node2.type == :input

            next if @genome.connection_exists?(node1.id, node2.id)

            # Do not create a connection if it would create a cycle
            next if @genome.path_exists?(node2.id, node1.id)

            create_new_connection(node1.id, node2.id)
            return {next_innovation_number: @next_innovation_number + 1}
          end

          nil
        end

        private

        def create_new_connection(in_node_id, out_node_id)
          new_connection = Morf::NEAT::ConnectionGene.new(
            in_node_id: in_node_id,
            out_node_id: out_node_id,
            weight: @mutation_strategy.random_connection_weight,
            enabled: true,
            innovation_number: @next_innovation_number
          )
          @genome.add_connection_gene(new_connection)
        end
      end
    end
  end
end
