# frozen_string_literal: true

require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

module Morf
  module NEAT
    class InitialPopulationFactory
      def create(size:, cppn_inputs:, cppn_outputs:, next_innovation_number:)
        genomes = Array.new(size) do
          node_genes = []
          input_nodes = cppn_inputs.times.map do |i|
            Morf::NEAT::NodeGene.new(id: i, type: :input, activation_function: :sigmoid)
          end
          output_nodes = cppn_outputs.times.map do |i|
            Morf::NEAT::NodeGene.new(id: cppn_inputs + i, type: :output, activation_function: :identity)
          end
          node_genes.concat(input_nodes)
          node_genes.concat(output_nodes)

          connection_genes = []
          first_input_node = input_nodes.first
          output_nodes.each do |output_node|
            connection_genes << Morf::NEAT::ConnectionGene.new(
              in_node_id: first_input_node.id,
              out_node_id: output_node.id,
              weight: 0.0,
              enabled: true,
              innovation_number: next_innovation_number
            )
            next_innovation_number += 1
          end

          Morf::NEAT::Genome.new(
            node_genes: node_genes,
            connection_genes: connection_genes
          )
        end

        {genomes: genomes, next_innovation_number: next_innovation_number}
      end
    end
  end
end
