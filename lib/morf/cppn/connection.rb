# frozen_string_literal: true

module Morf
  module CPPN
    class Connection
      attr_reader :input_node, :output_node, :weight

      def initialize(input_node:, output_node:, weight:)
        @input_node = input_node
        @output_node = output_node
        @weight = weight
      end

      def calculate
        input_node.calculate * weight
      end
    end
  end
end
