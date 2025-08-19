# frozen_string_literal: true

module Morf
  module CPPN
    class Network
      attr_reader :nodes, :connections

      def initialize(nodes:, connections:)
        @nodes = nodes
        @connections = connections
        populate_incoming_connections
      end

      def evaluate(inputs)
        @nodes.each(&:reset_cache)

        input_nodes = @nodes.select { |n| n.layer == :input }
        output_nodes = @nodes.select { |n| n.layer == :output }

        input_nodes.each_with_index do |node, i|
          node.input = inputs[i]
        end

        output_nodes.map(&:calculate)
      end

      def populate_incoming_connections
        @connections.each do |connection|
          connection.output_node.add_incoming_connection(connection)
        end
      end
    end
  end
end
