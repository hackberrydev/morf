# frozen_string_literal: true

require "spec_helper"
require "morf/experiments/neat/experiment"

RSpec.describe Morf::Experiments::NEAT::Experiment do
  subject(:experiment) { described_class.new(generations: 1, population_size: 10) }

  describe "#run" do
    let(:node_genes) do
      [
        Morf::NEAT::NodeGene.new(id: 0, type: :input, activation_function: :identity),
        Morf::NEAT::NodeGene.new(id: 1, type: :output, activation_function: :identity)
      ]
    end
    let(:genome) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: []) }
    let(:population) { Morf::NEAT::Population.new(genomes: [genome]) }
    let(:speciation) { instance_double(Morf::NEAT::Speciation, speciate: [[genome]]) }

    let(:initial_population_factory) do
      instance_double(
        Morf::NEAT::InitialPopulationFactory,
        create: {genomes: [genome], next_innovation_number: 1, next_node_id: 1}
      )
    end

    let(:trial_result) { double("Trial result", fitness: 0.5) }

    let(:developmental_trial) do
      instance_double(
        Morf::Experiments::NEAT::GenomeDevelopmentalTrial,
        evaluate: trial_result
      )
    end

    before do
      allow(Morf::NEAT::InitialPopulationFactory).to receive(:new).and_return(initial_population_factory)
      allow(Morf::Experiments::NEAT::GenomeDevelopmentalTrial).to receive(:new).and_return(developmental_trial)
      allow(Morf::NEAT::Speciation).to receive(:new).and_return(speciation)
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
