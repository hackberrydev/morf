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
      end

      def add_incoming_connection(connection)
        @incoming_connections << connection
      end
    end
  end
end
