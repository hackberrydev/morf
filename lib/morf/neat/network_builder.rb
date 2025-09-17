# frozen_string_literal: true

require "morf/cppn/network"
require "morf/cppn/node"
require "morf/cppn/connection"

module Morf
  module NEAT
    class NetworkBuilder
      def initialize(genome)
        @genome = genome
      end

      def build
        nodes = build_nodes
        connections = build_connections(nodes)
        Morf::CPPN::Network.new(nodes: nodes.values, connections: connections)
      end

      private

      def build_nodes
        @genome.node_genes.each_with_object({}) do |gene, hash|
          hash[gene.id] = Morf::CPPN::Node.new(
            id: gene.id,
            layer: gene.type,
            activation_function: gene.activation_function
          )
        end
      end

      def build_connections(nodes)
        @genome.connection_genes.select(&:enabled?).map do |gene|
          Morf::CPPN::Connection.new(
            input_node: nodes[gene.in_node_id],
            output_node: nodes[gene.out_node_id],
            weight: gene.weight
          )
        end
      end
    end
  end
end
