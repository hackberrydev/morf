# frozen_string_literal: true

require "morf/neat/mutation/add_node"
require "morf/neat/mutation/add_connection"
require "morf/neat/mutation/weights"

module Morf
  module NEAT
    module Mutation
      class Mutator
        attr_reader :next_node_id, :next_innovation_number

        def initialize(
          next_node_id:,
          next_innovation_number:,
          mutation_strategy:
        )
          @next_node_id = next_node_id
          @next_innovation_number = next_innovation_number
          @mutation_strategy = mutation_strategy
        end

        # Mutates the genome by applying different types of mutations.
        # Each mutation type has an independent probability of occurring,
        # meaning a genome can undergo multiple types of mutations at once.
        def mutate(genome)
          mutate_add_node(genome) if @mutation_strategy.add_node?
          mutate_add_connection(genome) if @mutation_strategy.add_connection?
          mutate_weights(genome) if @mutation_strategy.mutate_weights?
        end

        private

        def mutate_add_node(genome)
          result = AddNode.new(
            genome,
            mutation_strategy: @mutation_strategy,
            next_node_id: @next_node_id,
            next_innovation_number: @next_innovation_number
          ).call

          if result
            @next_node_id = result[:next_node_id]
            @next_innovation_number = result[:next_innovation_number]
          end
        end

        def mutate_add_connection(genome)
          result = AddConnection.new(
            genome,
            mutation_strategy: @mutation_strategy,
            next_innovation_number: @next_innovation_number,
            max_attempts: @mutation_strategy.add_connection_max_attempts
          ).call

          if result
            @next_innovation_number = result[:next_innovation_number]
          end
        end

        def mutate_weights(genome)
          Weights.new(
            genome,
            mutation_strategy: @mutation_strategy
          ).call
        end
      end
    end
  end
end
