# frozen_string_literal: true

module Morf
  module NEAT
    class Genome
      attr_reader :node_genes, :connection_genes

      def initialize(node_genes:, connection_genes:)
        @node_genes = node_genes
        @connection_genes = connection_genes
      end

      def add_node_gene(node_gene)
        @node_genes << node_gene
      end

      def add_connection_gene(connection_gene)
        @connection_genes << connection_gene
      end

      def connection_exists?(in_node_id, out_node_id)
        @connection_genes.any? do |gene|
          (gene.in_node_id == in_node_id && gene.out_node_id == out_node_id) ||
            (gene.in_node_id == out_node_id && gene.out_node_id == in_node_id)
        end
      end
    end
  end
end
