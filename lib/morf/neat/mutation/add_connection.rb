# frozen_string_literal: true

require "morf/neat/connection_gene"

module Morf
  module NEAT
    module Mutation
      class AddConnection
        def initialize(genome, mutation_strategy:, next_innovation_number:, max_attempts:)
          @genome = genome
          @mutation_strategy = mutation_strategy
          @next_innovation_number = next_innovation_number
          @max_attempts = max_attempts
        end

        def call
          @max_attempts.times do
            node1, node2 = @mutation_strategy.random_node_pair(@genome.node_genes)

            next if node1.id == node2.id # Prevent self-connection

            # Ensure the connection is feed-forward. If node1 is an output or node2 is an input, try swapping them.
            if node1.type == :output || node2.type == :input
              node1, node2 = node2, node1
            end

            # After potential swapping, if the connection is still not feed-forward, skip this attempt.
            next if node1.type == :output || node2.type == :input

            # Do not create a connection if it already exists
            next if @genome.connection_exists?(node1.id, node2.id)

            # Do not create a connection if it would create a cycle
            next if path_exists?(node2.id, node1.id)

            create_new_connection(node1.id, node2.id)
            return {next_innovation_number: @next_innovation_number + 1}
          end

          nil
        end

        private

        # Performs a breadth-first search to see if a path exists from `from_id` to `to_id`
        def path_exists?(from_id, to_id)
          stack = [from_id]
          visited = Set.new

          until stack.empty?
            current_id = stack.pop

            next if visited.include?(current_id)
            visited.add(current_id)

            @genome.connection_genes.each do |gene|
              next unless gene.enabled? && gene.in_node_id == current_id

              out_node_id = gene.out_node_id
              return true if out_node_id == to_id

              stack.push(out_node_id)
            end
          end

          false
        end

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
