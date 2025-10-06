# frozen_string_literal: true

require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

module Morf
  module NEAT
    class InitialPopulationFactory
      def create(size:, cppn_inputs:, cppn_outputs:, next_innovation_number:)
        input_nodes = create_input_nodes(cppn_inputs)
        output_nodes = create_output_nodes(cppn_inputs, cppn_outputs)
        node_genes = input_nodes + output_nodes

        connection_genes, next_innovation_number = create_connection_genes(
          input_nodes: input_nodes,
          output_nodes: output_nodes,
          next_innovation_number: next_innovation_number
        )

        genomes = Array.new(size) do
          Morf::NEAT::Genome.new(
            node_genes: node_genes.map(&:clone),
            connection_genes: connection_genes.map(&:clone)
          )
        end

        {
          genomes: genomes,
          next_innovation_number: next_innovation_number,
          next_node_id: cppn_inputs + cppn_outputs
        }
      end

      private

      def create_input_nodes(cppn_inputs)
        cppn_inputs.times.map do |i|
          Morf::NEAT::NodeGene.new(id: i, type: :input, activation_function: :sigmoid)
        end
      end

      def create_output_nodes(cppn_inputs, cppn_outputs)
        cppn_outputs.times.map do |i|
          Morf::NEAT::NodeGene.new(id: cppn_inputs + i, type: :output, activation_function: :identity)
        end
      end

      def create_connection_genes(input_nodes:, output_nodes:, next_innovation_number:)
        connection_genes = []

        input_nodes.each do |input_node|
          output_nodes.each do |output_node|
            connection_genes << Morf::NEAT::ConnectionGene.new(
              in_node_id: input_node.id,
              out_node_id: output_node.id,
              weight: rand * 2.0 - 1.0,
              enabled: true,
              innovation_number: next_innovation_number
            )
            next_innovation_number += 1
          end
        end

        [connection_genes, next_innovation_number]
      end
    end
  end
end
