# frozen_string_literal: true

module Morf
  module CPPN
    class Brain
      def initialize(network:)
        @network = network
      end

      def next_state(state, inputs)
        outputs = @network.evaluate([state] + inputs)
        outputs.each_with_index.max[1]
      end
    end
  end
end
