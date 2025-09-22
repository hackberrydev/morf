# frozen_string_literal: true

require "morf/clock"
require "morf/grid"
require "morf/cppn/sensor"
require "morf/experiments/neat/seed"

require "morf/static_brain_factory"

module Morf
  module Experiments
    module NEAT
      class GenomeDevelopmentalTrial
        def initialize(genome, target_pattern)
          @genome = genome
          @target_pattern = target_pattern
        end

        def evaluate
          network = Morf::NEAT::NetworkBuilder.new(@genome).build
          brain = Morf::CPPN::Brain.new(network: network)
          brain_factory = Morf::StaticBrainFactory.new(brain)

          clock = Morf::Clock.new
          seed = Morf::Experiments::NEAT::Seed.new(Morf::Experiments::NEAT::Constants::SEED_PATTERN)

          grid = Morf::Grid.new(
            rows: Morf::Experiments::NEAT::Constants::GRID_SIZE,
            columns: Morf::Experiments::NEAT::Constants::GRID_SIZE,
            seed: seed,
            sensor_class: Morf::CPPN::Sensor,
            brain_factory: brain_factory,
            clock: clock
          )

          fitness_calculator = Morf::NEAT::Fitness::PatternTarget.new(@target_pattern)

          raw_fitness_scores = []
          Morf::Experiments::NEAT::Constants::DEVELOPMENT_ITERATIONS.times do
            clock.cycle
            raw_fitness_scores << fitness_calculator.evaluate(grid)
          end

          max_raw_fitness = raw_fitness_scores.max

          # f(x) = x * (exp(5*x)) / exp(5)
          max_raw_fitness * Math.exp(5 * max_raw_fitness) / Math.exp(5)
        end
      end
    end
  end
end
