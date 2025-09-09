# frozen_string_literal: true

require "morf/neat/mutation/add_node"
require "morf/neat/mutation/add_connection"
require "morf/neat/mutation/weights"

module Morf
  module NEAT
    module Mutation
      class Mutator
        attr_reader :next_node_id, :next_innovation_number

        def initialize(random:,
          next_node_id:,
          next_innovation_number:,
          mutate_add_node_prob:,
          mutate_add_connection_prob:,
          mutate_weights_prob:,
          new_weight_prob:,
          weight_range:,
          add_connection_max_attempts:)
          @random = random
          @next_node_id = next_node_id
          @next_innovation_number = next_innovation_number
          @mutate_add_node_prob = mutate_add_node_prob
          @mutate_add_connection_prob = mutate_add_connection_prob
          @mutate_weights_prob = mutate_weights_prob
          @new_weight_prob = new_weight_prob
          @weight_range = weight_range
          @add_connection_max_attempts = add_connection_max_attempts
        end

        # Mutates the genome by applying different types of mutations.
        # Each mutation type has an independent probability of occurring,
        # meaning a genome can undergo multiple types of mutations at once.
        def mutate(genome)
          mutate_add_node(genome) if @random.rand < @mutate_add_node_prob
          mutate_add_connection(genome) if @random.rand < @mutate_add_connection_prob
          mutate_weights(genome) if @random.rand < @mutate_weights_prob
        end

        private

        def mutate_add_node(genome)
          result = AddNode.new(
            genome,
            random: @random,
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
            random: @random,
            next_innovation_number: @next_innovation_number,
            max_attempts: @add_connection_max_attempts
          ).call

          if result
            @next_innovation_number = result[:next_innovation_number]
          end
        end

        def mutate_weights(genome)
          Weights.new(
            genome,
            random: @random,
            new_weight_prob: @new_weight_prob,
            weight_range: @weight_range
          ).call
        end
      end
    end
  end
end
