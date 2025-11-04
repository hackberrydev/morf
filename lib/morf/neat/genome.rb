# frozen_string_literal: true

module Morf
  module NEAT
    class Genome
      attr_reader :node_genes, :connection_genes
      attr_accessor :fitness, :adjusted_fitness, :raw_fitness

      def initialize(node_genes:, connection_genes:)
        @node_genes = node_genes
        @connection_genes = connection_genes
      end

      def clone
        self.class.new(
          node_genes: @node_genes.map(&:clone),
          connection_genes: @connection_genes.map(&:clone)
        )
      end

      def add_node_gene(node_gene)
        @node_genes << node_gene
      end

      def add_connection_gene(connection_gene)
        @connection_genes << connection_gene
      end

      def connection_exists?(in_node_id, out_node_id)
        @connection_genes.any? do |gene|
          gene.in_node_id == in_node_id && gene.out_node_id == out_node_id
        end
      end

      # Performs a breadth-first search to see if a path exists from `from_id`
      # to `to_id`.
      def path_exists?(from_id, to_id)
        enabled_connections = @connection_genes.select(&:enabled?)
        stack = [from_id]
        visited = Set.new

        until stack.empty?
          current_id = stack.pop

          next if visited.include?(current_id)
          visited.add(current_id)

          enabled_connections.each do |gene|
            next unless gene.in_node_id == current_id

            out_node_id = gene.out_node_id
            return true if out_node_id == to_id

            stack.push(out_node_id)
          end
        end

        false
      end

      def nodes_count
        @node_genes.count
      end

      def connections_count
        @connection_genes.count
      end
    end
  end
end
