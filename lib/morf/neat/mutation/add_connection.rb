# frozen_string_literal: true

require "morf/neat/connection_gene"

module Morf
  module NEAT
    module Mutation
      class AddConnection
        def initialize(genome, random:, next_innovation_number:, max_attempts:)
          @genome = genome
          @random = random
          @next_innovation_number = next_innovation_number
          @max_attempts = max_attempts
        end

        def call
          @max_attempts.times do
            node1, node2 = @genome.node_genes.sample(2, random: @random)
            next if node1.nil? || node2.nil?
            next if @genome.connection_exists?(node1.id, node2.id)

            create_new_connection(node1.id, node2.id, @random.rand(-1.0..1.0), @next_innovation_number)
            return {next_innovation_number: @next_innovation_number + 1}
          end

          nil
        end

        private

        def create_new_connection(in_node_id, out_node_id, weight, innovation_number)
          new_connection = Morf::NEAT::ConnectionGene.new(
            in_node_id: in_node_id,
            out_node_id: out_node_id,
            weight: weight,
            enabled: true,
            innovation_number: innovation_number
          )
          @genome.add_connection_gene(new_connection)
        end
      end
    end
  end
end
