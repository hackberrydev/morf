# frozen_string_literal: true

require "morf/experiments/neat/constants"
require "morf/experiments/neat/genome_developmental_trial"
require "morf/neat/initial_population_factory"
require "morf/neat/reproduction"

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
          @population = Morf::NEAT::Population.new(
            size: @population_size,
            cppn_inputs: @cppn_inputs,
            cppn_outputs: @cppn_outputs
          )

          @generations.times do |generation|
            @population.genomes.each do |genome|
              trial = Morf::Experiments::NEAT::GenomeDevelopmentalTrial.new(
                genome,
                @target_pattern,
                grid_size: @grid_size,
                seed_pattern: @seed_pattern,
                development_iterations: Morf::Experiments::NEAT::Constants::DEVELOPMENT_ITERATIONS
              )
              genome.fitness = trial.evaluate
            end
          end
        end
      end
    end
  end
end
