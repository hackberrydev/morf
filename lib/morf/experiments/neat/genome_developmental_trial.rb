# frozen_string_literal: true

require "morf/clock"
require "morf/cppn/brain"
require "morf/sensors/von_neumann_sensor"
require "morf/experiments/neat/seed"
require "morf/grid"
require "morf/neat/fitness/pattern_target"
require "morf/neat/network_builder"
require "morf/static_brain_factory"

module Morf
  module Experiments
    module NEAT
      Result = Data.define(:raw_fitness, :fitness)

      class GenomeDevelopmentalTrial
        def initialize(genome, target_pattern, grid_size:, seed_pattern:, development_iterations:)
          @genome = genome
          @target_pattern = target_pattern
          @grid_size = grid_size
          @seed_pattern = seed_pattern
          @development_iterations = development_iterations
        end

        def evaluate
          network = Morf::NEAT::NetworkBuilder.new(@genome).build
          brain = Morf::CPPN::Brain.new(network: network)
          brain_factory = Morf::StaticBrainFactory.new(brain)

          clock = Morf::Clock.new
          seed = Morf::Experiments::NEAT::Seed.new(@seed_pattern)

          grid = Morf::Grid.new(
            rows: @grid_size,
            columns: @grid_size,
            seed: seed,
            sensor_class: Morf::Sensors::VonNeumannSensor,
            brain_factory: brain_factory,
            clock: clock
          )

          fitness_calculator = Morf::NEAT::Fitness::PatternTarget.new(@target_pattern)

          raw_fitness_scores = []
          @development_iterations.times do
            clock.cycle
            raw_fitness_scores << fitness_calculator.evaluate(grid)
          end

          max_raw_fitness = raw_fitness_scores.max

          # f(x) = x * (exp(5*x)) / exp(5)
          fitness = max_raw_fitness * Math.exp(5 * max_raw_fitness) / Math.exp(5)

          Result.new(fitness: fitness, raw_fitness: max_raw_fitness)
        end
      end
    end
  end
end
