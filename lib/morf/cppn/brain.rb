# frozen_string_literal: true

module Morf
  module CPPN
    class Brain
      def initialize(network:)
        @network = network
      end

      def next_state(state, inputs)
        normalized_inputs = normalize_inputs([state] + inputs)
        outputs = @network.evaluate(normalized_inputs)
        outputs.each_with_index.max[1]
      end

      private

      def normalize_inputs(inputs)
        num_states = @network.output_nodes.size
        inputs.map { |value| (value.to_f / num_states) * 2.0 - 1.0 }
      end
    end
  end
end
