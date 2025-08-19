# frozen_string_literal: true

require "morf/cppn/activation_functions"

module Morf
  module CPPN
    class Node
      attr_reader :id, :layer, :activation_function

      def initialize(id:, layer:, activation_function:)
        @id = id
        @layer = layer
        @activation_function = activation_function
      end
    end
  end
end
