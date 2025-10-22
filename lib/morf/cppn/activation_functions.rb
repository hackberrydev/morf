# frozen_string_literal: true

module Morf
  module CPPN
    module ActivationFunctions
      ALL = [
        :sigmoid, :tanh, :sin, :gauss, :relu, :identity,
        :clamped, :inv, :log, :exp, :abs, :hat, :square, :cube
      ].freeze

      def self.sigmoid(x)
        process_output(1.0 / (1.0 + Math.exp(-x)), x)
      end

      def self.tanh(x)
        process_output(Math.tanh(x), x)
      end

      def self.sin(x)
        process_output(Math.sin(x), x)
      end

      def self.gauss(x)
        process_output(Math.exp(-x**2), x)
      end

      def self.relu(x)
        process_output([0, x].max, x)
      end

      def self.identity(x)
        process_output(x, x)
      end

      def self.clamped(x)
        process_output(x.clamp(-1.0, 1.0), x)
      end

      def self.inv(x)
        return 0.0 if x.zero?

        process_output(1.0 / x, x)
      end

      def self.log(x)
        return 0.0 if x <= 0.0

        process_output(Math.log(x), x)
      end

      def self.exp(x)
        process_output(Math.exp(x), x)
      end

      def self.abs(x)
        process_output(x.abs, x)
      end

      def self.hat(x)
        return 0.0 if x.abs > 1.0

        process_output(1.0 - x.abs, x)
      end

      def self.square(x)
        process_output(x**2, x)
      end

      def self.cube(x)
        process_output(x**3, x)
      end

      def self.process_output(result, x)
        return result if result.integer?

        if result.nan? || result.infinite?
          raise "Result is #{result.inspect} for #{x}"
        end

        result
      end

      def self.random(random:)
        ALL.sample(random: random)
      end
    end
  end
end
