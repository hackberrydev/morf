# frozen_string_literal: true

module Morf
  module CPPN
    class Network
      attr_reader :nodes, :connections

      def initialize(nodes:, connections:)
        @nodes = nodes
        @connections = connections
      end
    end
  end
end
