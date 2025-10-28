# frozen_string_literal: true

module Morf
  module NEAT
    module Mutation
      class Configuration
        attr_reader :weight_range,
          :add_node_prob,
          :add_connection_prob,
          :weights_prob,
          :new_weight_prob,
          :add_connection_max_attempts

        def initialize(
          weight_range: -4.0..4.0,
          add_node_prob: 0.03,
          add_connection_prob: 0.05,
          weights_prob: 0.8,
          new_weight_prob: 0.1,
          add_connection_max_attempts: 10
        )
          @weight_range = weight_range
          @add_node_prob = add_node_prob
          @add_connection_prob = add_connection_prob
          @weights_prob = weights_prob
          @new_weight_prob = new_weight_prob
          @add_connection_max_attempts = add_connection_max_attempts
        end
      end
    end
  end
end
