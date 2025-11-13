# frozen_string_literal: true

module Morf
  module Experiments
    module NEAT
      class OffspringAllocator
        def initialize(population_size:)
          @population_size = population_size
        end

        def allocate(species)
          if all_zero_fitness?(species)
            allocate_evenly(species)
          else
            allocate_proportionally(species)
          end
        end

        private

        def all_zero_fitness?(species)
          species.sum { |s| s.sum(&:adjusted_fitness) }.zero?
        end

        def allocate_evenly(species)
          base_count = @population_size / species.size
          counts = Array.new(species.size, base_count)
          distribute_remainders(counts, @population_size % species.size)
          counts
        end

        def allocate_proportionally(species)
          total_fitness = species.sum { |s| s.sum(&:adjusted_fitness) }
          offspring_floats = species.map do |s|
            (s.sum(&:adjusted_fitness) / total_fitness) * @population_size
          end

          counts = offspring_floats.map(&:to_i)
          remainders = calculate_remainders(offspring_floats, counts)
          missing = @population_size - counts.sum
          distribute_by_remainders(counts, remainders, missing)
          counts
        end

        def calculate_remainders(floats, integers)
          floats.map.with_index { |f, i| [f - integers[i], i] }
            .sort_by { |remainder, _| -remainder }
        end

        def distribute_remainders(counts, remainder_count)
          remainder_count.times { |i| counts[i] += 1 }
        end

        def distribute_by_remainders(counts, remainders, missing_count)
          missing_count.times do |i|
            species_index = remainders[i][1]
            counts[species_index] += 1
          end
        end
      end
    end
  end
end
