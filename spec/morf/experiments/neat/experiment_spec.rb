# frozen_string_literal: true

require "spec_helper"
require "morf/experiments/neat/experiment"

RSpec.describe Morf::Experiments::NEAT::Experiment do
  subject(:experiment) { described_class.new(generations: 1, population_size: 10) }

  describe "#run" do
    let(:genome) { Morf::NEAT::Genome.new(node_genes: [], connection_genes: []) }
    let(:population) { Morf::NEAT::Population.new(genomes: [genome]) }
    let(:initial_population_factory) { instance_double(Morf::NEAT::InitialPopulationFactory) }
    let(:developmental_trial) { instance_double(Morf::Experiments::NEAT::GenomeDevelopmentalTrial) }
    let(:speciation) { instance_double(Morf::NEAT::Speciation) }

    before do
      allow(Morf::NEAT::InitialPopulationFactory).to receive(:new).and_return(initial_population_factory)
      allow(initial_population_factory).to receive(:create).and_return({genomes: [genome], next_innovation_number: 1})
      allow(Morf::Experiments::NEAT::GenomeDevelopmentalTrial).to receive(:new).and_return(developmental_trial)
      allow(developmental_trial).to receive(:evaluate).and_return(0.5)
      allow(Morf::NEAT::Speciation).to receive(:new).and_return(speciation)
      allow(speciation).to receive(:speciate).and_return([[genome]])
      allow(File).to receive(:open).and_yield(nil)
      allow(Marshal).to receive(:dump)
      allow($stdout).to receive(:puts) # Suppress output
    end

    it "runs without errors" do
      expect { experiment.run }.not_to raise_error
    end

    it "saves the best genome" do
      experiment.run
      expect(Marshal).to have_received(:dump)
    end
  end
end
