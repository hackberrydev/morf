# frozen_string_literal: true

module Morf
  module NEAT
    class ConnectionGene
      attr_reader :in_node_id, :out_node_id, :enabled, :innovation_number
      attr_accessor :weight

      def initialize(in_node_id:, out_node_id:, weight:, enabled:, innovation_number:)
        @in_node_id = in_node_id
        @out_node_id = out_node_id
        @weight = weight
        @enabled = enabled
        @innovation_number = innovation_number
      end

      def disable
        @enabled = false
      end

      def enabled?
        @enabled
      end
    end
  end
end
