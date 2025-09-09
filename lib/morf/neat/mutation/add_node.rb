# frozen_string_literal: true

require "morf/neat/node_gene"
require "morf/neat/connection_gene"

module Morf
  module NEAT
    module Mutation
      class AddNode
        def initialize(genome, random:, next_node_id:, next_innovation_number:)
          @genome = genome
          @random = random
          @next_node_id = next_node_id
          @next_innovation_number = next_innovation_number
        end

        def call
          connection_to_split = @genome.connection_genes.sample(random: @random)
          return if connection_to_split.nil?

          connection_to_split.disable

          new_node = Morf::NEAT::NodeGene.new(id: @next_node_id, type: :hidden, activation_function: :sigmoid)
          @genome.add_node_gene(new_node)

          create_new_connection(connection_to_split.in_node_id, new_node.id, 1.0, @next_innovation_number)
          create_new_connection(new_node.id, connection_to_split.out_node_id, connection_to_split.weight, @next_innovation_number + 1)

          {next_node_id: @next_node_id + 1, next_innovation_number: @next_innovation_number + 2}
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
