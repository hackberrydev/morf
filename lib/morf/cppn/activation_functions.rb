# frozen_string_literal: true

module Morf
  module CPPN
    module ActivationFunctions
      def self.sigmoid(x)
        1.0 / (1.0 + Math.exp(-x))
      end

      def self.identity(x)
        x
      end
    end
  end
end
