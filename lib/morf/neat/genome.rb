# frozen_string_literal: true

module Morf
  module NEAT
    class Genome
      attr_reader :node_genes, :connection_genes

      def initialize(node_genes:, connection_genes:)
        @node_genes = node_genes
        @connection_genes = connection_genes
      end
    end
  end
end
