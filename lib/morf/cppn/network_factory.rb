# frozen_string_literal: true

require "morf/cppn/network"
require "morf/cppn/node"
require "morf/cppn/connection"

module Morf
  module CPPN
    class NetworkFactory
      def self.build(num_inputs:, num_outputs:, input_activation_function:, output_activation_function:)
        node_id_counter = 0
        input_nodes = Array.new(num_inputs) do
          Node.new(
            id: node_id_counter += 1,
            layer: :input,
            activation_function: input_activation_function
          )
        end

        output_nodes = Array.new(num_outputs) do
          Node.new(
            id: node_id_counter += 1,
            layer: :output,
            activation_function: output_activation_function
          )
        end

        connections = []
        input_nodes.each do |input_node|
          output_nodes.each do |output_node|
            connections << Connection.new(input_node: input_node, output_node: output_node, weight: rand(-1.0..1.0))
          end
        end

        Network.new(nodes: input_nodes + output_nodes, connections: connections)
      end
    end
  end
end
