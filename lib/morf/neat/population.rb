# frozen_string_literal: true

module Morf
  module NEAT
    class Population
      attr_reader :genomes

      def initialize(genomes:)
        @genomes = genomes
      end

      def best_fitness
        @genomes.map(&:fitness).max
      end

      def average_fitness
        @genomes.map(&:fitness).sum / @genomes.size.to_f
      end

      def best_genome
        @genomes.max_by(&:fitness)
      end
    end
  end
end
