# frozen_string_literal: true

module Morf
  module NEAT
    class NodeGene
      attr_reader :id, :type, :activation_function

      def initialize(id:, type:, activation_function:)
        @id = id
        @type = type
        @activation_function = activation_function
      end
    end
  end
end
