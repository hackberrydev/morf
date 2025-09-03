# frozen_string_literal: true

module Morf
  module NEAT
    class Speciation
      # @param population [Array<Morf::NEAT::Genome>] The population of genomes to be speciated.
      # @param compatibility_threshold [Float] The compatibility threshold. If the distance between two
      #   genomes is less than this value, they are considered to be in the same species.
      # @param c1 [Float] The coefficient for excess genes. It adjusts the importance of excess genes in
      #   the distance calculation.
      # @param c2 [Float] The coefficient for disjoint genes. It adjusts the importance of disjoint genes
      #   in the distance calculation.
      # @param c3 [Float] The coefficient for the average weight difference. It adjusts the importance of
      #   the average weight difference of matching genes in the distance calculation.
      def initialize(population:, compatibility_threshold:, c1:, c2:, c3:)
        @population = population
        @compatibility_threshold = compatibility_threshold
        @c1 = c1
        @c2 = c2
        @c3 = c3
      end

      def distance(genome1, genome2)
        genes1 = genome1.connection_genes.sort_by(&:innovation_number)
        genes2 = genome2.connection_genes.sort_by(&:innovation_number)

        return 0.0 if genes1.empty? && genes2.empty?

        idx1 = 0
        idx2 = 0
        disjoint = 0
        weight_diff = 0.0
        matching = 0

        while idx1 < genes1.length && idx2 < genes2.length
          gene1 = genes1[idx1]
          gene2 = genes2[idx2]

          if gene1.innovation_number == gene2.innovation_number
            matching += 1
            weight_diff += (gene1.weight - gene2.weight).abs
            idx1 += 1
            idx2 += 1
          elsif gene1.innovation_number < gene2.innovation_number
            disjoint += 1
            idx1 += 1
          else # gene2.innovation_number < gene1.innovation_number
            disjoint += 1
            idx2 += 1
          end
        end

        excess = (genes1.length - idx1) + (genes2.length - idx2)

        n = [genes1.length, genes2.length].max
        n = 1 if n < 20

        avg_weight_diff = matching.zero? ? 0 : weight_diff / matching

        term1 = @c1 * excess / n.to_f
        term2 = @c2 * disjoint / n.to_f
        term3 = @c3 * avg_weight_diff

        term1 + term2 + term3
      end

      def speciate
        species = []

        @population.each do |genome|
          found_species = false
          species.each do |s|
            representative = s.first
            if distance(genome, representative) < @compatibility_threshold
              s << genome
              found_species = true
              break
            end
          end

          species << [genome] unless found_species
        end

        species
      end
    end
  end
end
