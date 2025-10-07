# frozen_string_literal: true

require "csv"

require "morf/experiments/neat/constants"
require "morf/experiments/neat/genome_developmental_trial"
require "morf/neat/initial_population_factory"
require "morf/neat/population"
require "morf/neat/reproduction"
require "morf/neat/speciation"

module Morf
  module Experiments
    module NEAT
      class Experiment
        def initialize(
          population_size: Constants::POPULATION_SIZE,
          generations: Constants::GENERATIONS,
          grid_size: Constants::GRID_SIZE,
          seed_pattern: Constants::SEED_PATTERN,
          target_pattern: Constants::FRENCH_FLAG_PATTERN,
          cppn_inputs: Constants::CPPN_INPUTS,
          cppn_outputs: Constants::CPPN_OUTPUTS
        )
          @population_size = population_size
          @generations = generations
          @grid_size = grid_size
          @seed_pattern = seed_pattern
          @target_pattern = target_pattern
          @cppn_inputs = cppn_inputs
          @cppn_outputs = cppn_outputs
        end

        def run
          puts CSV.generate_line([
            "Generation",
            "Target Population",
            "Population",
            "Species",
            "Max Fitness",
            "Max Raw Fitness",
            "Average Fitness",
            "Max Nodes",
            "Max Connections"
          ])

          initial_population_factory = Morf::NEAT::InitialPopulationFactory.new
          result = initial_population_factory.create(
            size: @population_size,
            cppn_inputs: @cppn_inputs,
            cppn_outputs: @cppn_outputs,
            next_innovation_number: 0
          )
          @population = Morf::NEAT::Population.new(genomes: result[:genomes])
          next_innovation_number = result[:next_innovation_number]
          next_node_id = result[:next_node_id]
          best_genome_overall = nil

          reproduction = Morf::NEAT::Reproduction.new(
            next_node_id: next_node_id,
            next_innovation_number: next_innovation_number,
            weight_range: -30.0..30.0,
            mutate_add_node_prob: 0.5,
            mutate_add_connection_prob: 0.5
          )

          @generations.times do |generation|
            @population.genomes.each { |genome| run_developmental_trial(genome) }

            best_genome_generation = @population.genomes.max_by(&:fitness)
            if best_genome_overall.nil? || best_genome_generation.fitness > best_genome_overall.fitness
              best_genome_overall = best_genome_generation
            end

            species = separate_population_into_species(@population)

            avg_fitness = @population.genomes.sum(&:fitness) / @population.genomes.size
            max_nodes = @population.genomes.map(&:nodes_count).max
            max_connections = @population.genomes.map(&:connections_count).max

            puts CSV.generate_line([
              generation,
              @population_size,
              species.sum(&:count),
              species.size,
              best_genome_generation.fitness,
              best_genome_generation.raw_fitness,
              avg_fitness,
              max_nodes,
              max_connections
            ])

            # Calculate adjusted fitness
            species.each do |s|
              s.each do |genome|
                genome.adjusted_fitness = genome.fitness / s.size
              end
            end

            # Determine offspring counts
            total_adjusted_fitness = @population.genomes.sum(&:adjusted_fitness)
            if total_adjusted_fitness.zero?
              # Handle the case where all fitnesses are zero
              species_offspring_counts = Array.new(species.size, @population_size / species.size)
              (@population_size % species.size).times { |i| species_offspring_counts[i] += 1 }
            else
              offspring_floats = species.map do |s|
                species_adjusted_fitness = s.sum(&:adjusted_fitness)
                species_adjusted_fitness / total_adjusted_fitness * @population_size
              end

              species_offspring_counts = offspring_floats.map(&:to_i)
              remainders = offspring_floats.map.with_index { |f, i| [f - species_offspring_counts[i], i] }
              remainders.sort_by! { |r, _| -r } # Sort by remainder descending

              missing_offspring = @population_size - species_offspring_counts.sum
              missing_offspring.times do |i|
                species_index = remainders[i][1]
                species_offspring_counts[species_index] += 1
              end
            end

            # Create next generation
            next_generation = []
            species.each_with_index do |s, i|
              # Elitism
              s.sort_by!(&:fitness).reverse!
              next_generation << s.first if s.first

              # Crossover and mutation
              (species_offspring_counts[i] - 1).times do
                parent1 = s.sample
                parent2 = s.sample

                child = if parent1.fitness > parent2.fitness
                  reproduction.crossover(parent1, parent2, parent1.fitness, parent2.fitness)
                else
                  reproduction.crossover(parent2, parent1, parent2.fitness, parent1.fitness)
                end

                reproduction.mutate(child)
                next_generation << child
              end
            end

            @population = Morf::NEAT::Population.new(genomes: next_generation)
          end

          # Save the best genome
          timestamp = Time.now.strftime("%Y%m%d-%H%M%S")
          filename = "genomes/best_genome-#{timestamp}.dump"
          File.open(filename, "wb") do |f|
            Marshal.dump(best_genome_overall, f)
          end
          puts "Saved best genome to #{filename}"
        end

        private

        def run_developmental_trial(genome)
          trial = Morf::Experiments::NEAT::GenomeDevelopmentalTrial.new(
            genome,
            @target_pattern,
            grid_size: @grid_size,
            seed_pattern: @seed_pattern,
            development_iterations: Morf::Experiments::NEAT::Constants::DEVELOPMENT_ITERATIONS
          )
          result = trial.evaluate
          genome.fitness = result.fitness
          genome.raw_fitness = result.raw_fitness
        end

        def separate_population_into_species(population)
          speciation = Morf::NEAT::Speciation.new(
            population: population.genomes,
            compatibility_threshold: Constants::COMPATIBILITY_THRESHOLD,
            c1: Constants::C1,
            c2: Constants::C2,
            c3: Constants::C3
          )

          speciation.speciate
        end
      end
    end
  end
end
