# frozen_string_literal: true

require "morf/cppn/activation_functions"

module Morf
  module CPPN
    class Node
      attr_reader :id, :layer, :activation_function, :incoming_connections

      def initialize(id:, layer:, activation_function:)
        @id = id
        @layer = layer
        @activation_function = activation_function
        @incoming_connections = []
        @cached_value = nil
      end

      def add_incoming_connection(connection)
        @incoming_connections << connection
      end

      def reset_cache
        @cached_value = nil
      end

      def input=(value)
        @cached_value = value
      end

      def calculate
        return @cached_value if @cached_value

        sum = incoming_connections.sum(&:calculate)

        @cached_value = activate(sum)
      end

      def input?
        layer == :input
      end

      def output?
        layer == :output
      end

      private

      def activate(value)
        ActivationFunctions.send(activation_function, value)
      end
    end
  end
end
