# frozen_string_literal: true

require "morf/cppn/brain"
require "morf/neat/network_builder"

module Morf
  module NEAT
    class BrainFactory
      def initialize(genome)
        @genome = genome
      end

      def create_brain
        network = NetworkBuilder.new(@genome).build
        Morf::CPPN::Brain.new(network: network)
      end
    end
  end
end
