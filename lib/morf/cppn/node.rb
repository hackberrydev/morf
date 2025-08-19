# frozen_string_literal: true

module Morf
  module CPPN
    class Node
      attr_reader :id, :layer

      def initialize(id:, layer:)
        @id = id
        @layer = layer
      end
    end
  end
end
