# frozen_string_literal: true

require "morf/clock"
require "morf/sensors/von_neumann_sensor"
require "morf/experiments/neat/seed"
require "morf/grid"
require "morf/neat/fitness/pattern_target"
require "morf/neat/brain_factory"

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
          @clock = Morf::Clock.new
        end

        def evaluate
          max_raw_fitness = run_trial

          # f(x) = x * (exp(5*x)) / exp(5)
          fitness = max_raw_fitness * Math.exp(5 * max_raw_fitness) / Math.exp(5)

          Result.new(fitness: fitness, raw_fitness: max_raw_fitness)
        end

        private

        def run_trial
          grid = build_grid
          fitness_calculator = Morf::NEAT::Fitness::PatternTarget.new(@target_pattern)

          raw_fitness_scores = []

          @development_iterations.times do
            @clock.cycle
            raw_fitness_scores << fitness_calculator.evaluate(grid)
          end

          raw_fitness_scores.max
        end

        def build_grid
          Morf::Grid.new(
            rows: @grid_size,
            columns: @grid_size,
            seed: Morf::Experiments::NEAT::Seed.new(@seed_pattern),
            sensor_class: Morf::Sensors::VonNeumannSensor,
            brain_factory: Morf::NEAT::BrainFactory.new(@genome),
            clock: @clock
          )
        end
      end
    end
  end
end
