# frozen_string_literal: true

module Morf
  module NEAT
    module Mutation
      class MutationStrategy
        attr_reader :random,
          :weight_range,
          :add_node_prob,
          :add_connection_prob,
          :weights_prob,
          :new_weight_prob,
          :add_connection_max_attempts

        def initialize(
          random:,
          weight_range: -4.0..4.0,
          add_node_prob: 0.03,
          add_connection_prob: 0.05,
          weights_prob: 0.8,
          new_weight_prob: 0.1,
          add_connection_max_attempts: 10
        )
          @random = random
          @weight_range = weight_range
          @add_node_prob = add_node_prob
          @add_connection_prob = add_connection_prob
          @weights_prob = weights_prob
          @new_weight_prob = new_weight_prob
          @add_connection_max_attempts = add_connection_max_attempts
        end

        def add_node?
          @random.rand < @add_node_prob
        end

        def add_connection?
          @random.rand < @add_connection_prob
        end

        def mutate_weights?
          @random.rand < @weights_prob
        end

        def mutate_weight(current_weight)
          if @random.rand < @new_weight_prob
            @random.rand(-1.0..1.0)
          else
            (current_weight + @random.rand(-0.1..0.1)).clamp(@weight_range)
          end
        end

        def random_node_pair(nodes)
          nodes.sample(2, random: @random)
        end

        def random_connection_weight
          @random.rand(-1.0..1.0)
        end

        def random_connection(connections)
          connections.sample(random: @random)
        end

        def random_activation_function
          Morf::CPPN::ActivationFunctions.random(random: @random)
        end
      end
    end
  end
end
