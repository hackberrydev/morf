# frozen_string_literal: true

module Morf
  module CPPN
    module ActivationFunctions
      def self.sigmoid(x)
        1.0 / (1.0 + Math.exp(-x))
      end

      def self.tanh(x)
        Math.tanh(x)
      end

      def self.sin(x)
        Math.sin(x)
      end

      def self.gauss(x)
        Math.exp(-x**2)
      end

      def self.relu(x)
        [0, x].max
      end

      def self.identity(x)
        x
      end

      def self.clamped(x)
        x.clamp(-1.0, 1.0)
      end

      def self.inv(x)
        return 0.0 if x.zero?

        1.0 / x
      end

      def self.log(x)
        return 0.0 if x <= 0.0

        Math.log(x)
      end

      def self.exp(x)
        Math.exp(x)
      end

      def self.abs(x)
        x.abs
      end

      def self.hat(x)
        return 0.0 if x.abs > 1.0

        1.0 - x.abs
      end

      def self.square(x)
        x**2
      end

      def self.cube(x)
        x**3
      end
    end
  end
end
