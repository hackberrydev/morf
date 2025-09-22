# frozen_string_literal: true

require "spec_helper"
require "morf/experiments/neat/genome_developmental_trial"
require "morf/experiments/neat/constants"
require "morf/neat/genome"
require "morf/neat/network_builder"
require "morf/cppn/brain"
require "morf/grid"
require "morf/clock"
require "morf/neat/fitness/pattern_target"

require "morf/cppn/sensor"
require "morf/experiments/neat/seed"

require "morf/static_brain_factory"

RSpec.describe Morf::Experiments::NEAT::GenomeDevelopmentalTrial do
  subject(:trial) { described_class.new(genome, target_pattern) }

  let(:genome) { instance_double(Morf::NEAT::Genome) }
  let(:target_pattern) { Morf::Experiments::NEAT::Constants::FRENCH_FLAG_PATTERN }
  let(:cppn_network) { instance_double(Morf::CPPN::Network) }
  let(:cppn_brain) { instance_double(Morf::CPPN::Brain) }
  let(:clock) { instance_double(Morf::Clock, cycle: nil) }
  let(:grid) { instance_double(Morf::Grid) }
  let(:pattern_target) { instance_double(Morf::NEAT::Fitness::PatternTarget) }
  let(:seed) { instance_double(Morf::Experiments::NEAT::Seed) }
  let(:brain_factory) { instance_double(Morf::StaticBrainFactory) }

  before do
    allow(Morf::Clock).to receive(:new).and_return(clock)
    allow(Morf::Experiments::NEAT::Seed).to receive(:new).with(Morf::Experiments::NEAT::Constants::SEED_PATTERN).and_return(seed)

    # Stub the sequence of object creations that will happen inside `evaluate`
    allow(Morf::NEAT::NetworkBuilder).to receive(:new).with(genome).and_return(double(build: cppn_network))
    allow(Morf::CPPN::Brain).to receive(:new).with(network: cppn_network).and_return(cppn_brain)
    allow(Morf::StaticBrainFactory).to receive(:new).with(cppn_brain).and_return(brain_factory)

    allow(Morf::Grid).to receive(:new).with(
      rows: Morf::Experiments::NEAT::Constants::GRID_SIZE,
      columns: Morf::Experiments::NEAT::Constants::GRID_SIZE,
      seed: seed,
      sensor_class: Morf::CPPN::Sensor,
      brain_factory: brain_factory,
      clock: clock
    ).and_return(grid)

    allow(Morf::NEAT::Fitness::PatternTarget).to receive(:new).with(target_pattern).and_return(pattern_target)
  end

  describe "#evaluate" do
    it "runs the full developmental trial and returns the scaled fitness" do
      # Simulate a sequence of raw fitness scores during development
      raw_fitness_scores = [0.5, 0.7, 0.9, 0.85]
      raw_fitness_scores.fill(raw_fitness_scores.last, raw_fitness_scores.length...Morf::Experiments::NEAT::Constants::DEVELOPMENT_ITERATIONS)
      allow(pattern_target).to receive(:evaluate).with(grid).and_return(*raw_fitness_scores)

      max_raw_fitness = 0.9
      expected_scaled_fitness = max_raw_fitness * Math.exp(5 * max_raw_fitness) / Math.exp(5)

      aggregate_failures do
        expect(trial.evaluate).to be_within(0.0001).of(expected_scaled_fitness)

        # Expect the clock to be cycled for each development iteration
        expect(clock).to have_received(:cycle).exactly(Morf::Experiments::NEAT::Constants::DEVELOPMENT_ITERATIONS).times
      end
    end
  end
end
