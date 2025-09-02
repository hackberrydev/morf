# frozen_string_literal: true

module Morf
  module NEAT
    class Population
      attr_reader :genomes

      def initialize(genomes:)
        @genomes = genomes
      end
    end
  end
end
