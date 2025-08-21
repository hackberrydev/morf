# frozen_string_literal: true

require "morf/cppn/network"

module Morf
  module CPPN
    class Brain
      def initialize(network:)
        @network = network
      end

      def next_state(state, inputs)
        @network.evaluate([state] + inputs).first
      end
    end
  end
end
