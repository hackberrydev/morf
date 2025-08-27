# frozen_string_literal: true

require "morf/cppn/brain"
require "morf/cppn/network_factory"
require "morf/cppn/activation_functions"

module Morf
  module Experiments
    module CPPN
      class Brain
        def initialize
          network = Morf::CPPN::NetworkFactory.build(
            num_inputs: 9,
            num_outputs: 4,
            input_activation_function: :sigmoid,
            output_activation_function: :identity
          )
          @brain = Morf::CPPN::Brain.new(network: network)
        end

        def next_state(state, inputs)
          normalized_state = (0.5 * state) - 1.0
          normalized_inputs = inputs.map { |i| (0.5 * i) - 1.0 }

          @brain.next_state(normalized_state, normalized_inputs)
        end
      end
    end
  end
end
