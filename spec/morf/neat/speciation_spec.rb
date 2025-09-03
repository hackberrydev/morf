# frozen_string_literal: true

require "spec_helper"
require "morf/neat/speciation"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::Speciation do
  subject(:speciation) do
    described_class.new(
      population: population,
      compatibility_threshold: 3.0,
      c1: 1.0,
      c2: 1.0,
      c3: 0.4
    )
  end

  let(:population) { [genome1, genome2] }
  let(:genome1) { Morf::NEAT::Genome.new(node_genes: node_genes1, connection_genes: connection_genes1) }
  let(:genome2) { Morf::NEAT::Genome.new(node_genes: node_genes2, connection_genes: connection_genes2) }

  let(:node_genes1) do
    [
      Morf::NEAT::NodeGene.new(id: 1, type: :input, activation_function: :identity),
      Morf::NEAT::NodeGene.new(id: 2, type: :output, activation_function: :sigmoid),
      Morf::NEAT::NodeGene.new(id: 3, type: :hidden, activation_function: :sigmoid)
    ]
  end

  let(:connection_genes1) do
    [
      Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 0.5, innovation_number: 1, enabled: true),
      Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 3, weight: 0.5, innovation_number: 2, enabled: true),
      Morf::NEAT::ConnectionGene.new(in_node_id: 3, out_node_id: 2, weight: 0.5, innovation_number: 3, enabled: true)
    ]
  end

  let(:node_genes2) { node_genes1 }
  let(:connection_genes2) { connection_genes1 }

  describe "#distance" do
    context "with identical genomes" do
      it "is 0" do
        expect(speciation.distance(genome1, genome2)).to eq(0)
      end
    end

    context "with disjoint genes" do
      let(:connection_genes2) do
        [
          Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 0.5, innovation_number: 1, enabled: true),
          Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 3, weight: 0.5, innovation_number: 2, enabled: true),
          Morf::NEAT::ConnectionGene.new(in_node_id: 3, out_node_id: 2, weight: 0.5, innovation_number: 4, enabled: true)
        ]
      end

      it "calculates the distance" do
        # With small genomes (n < 20), n is set to 1.
        # N = 1
        # D = 1 (innovation 3)
        # E = 1 (innovation 4)
        # W = 0
        # distance = (1.0 * 1 / 1) + (1.0 * 1 / 1) + 0 = 2.0
        expect(speciation.distance(genome1, genome2)).to be_within(0.001).of(2.0)
      end
    end

    context "with excess genes" do
      let(:connection_genes2) do
        [
          Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 0.5, innovation_number: 1, enabled: true),
          Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 3, weight: 0.5, innovation_number: 2, enabled: true),
          Morf::NEAT::ConnectionGene.new(in_node_id: 3, out_node_id: 2, weight: 0.5, innovation_number: 3, enabled: true),
          Morf::NEAT::ConnectionGene.new(in_node_id: 2, out_node_id: 3, weight: 0.5, innovation_number: 4, enabled: true)
        ]
      end

      it "calculates the distance" do
        # With small genomes (n < 20), n is set to 1.
        # N = 1.
        # E = 1 (gene with innov 4).
        # D = 0.
        # W = 0.
        # distance = (1.0 * 1 / 1) + (1.0 * 0 / 1) + 0 = 1.0
        expect(speciation.distance(genome1, genome2)).to be_within(0.001).of(1.0)
      end
    end

    context "with different weights" do
      let(:connection_genes2) do
        [
          Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 1.0, innovation_number: 1, enabled: true),
          Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 3, weight: 1.0, innovation_number: 2, enabled: true),
          Morf::NEAT::ConnectionGene.new(in_node_id: 3, out_node_id: 2, weight: 1.0, innovation_number: 3, enabled: true)
        ]
      end

      it "calculates the distance" do
        # N is not used in the weight term, so the n=1 optimization does not affect this test.
        # N = 1. E = 0. D = 0.
        # weight diffs are |0.5 - 1.0| = 0.5 for all 3 matching genes.
        # W = 0.5
        # distance = 0 + 0 + c3 * W = 0.4 * 0.5 = 0.2
        expect(speciation.distance(genome1, genome2)).to be_within(0.001).of(0.2)
      end
    end
  end

  describe "#speciate" do
    let(:genome3) do
      # a genome that is similar to genome1 and genome2
      node_genes = [
        Morf::NEAT::NodeGene.new(id: 1, type: :input, activation_function: :identity),
        Morf::NEAT::NodeGene.new(id: 2, type: :output, activation_function: :sigmoid),
        Morf::NEAT::NodeGene.new(id: 3, type: :hidden, activation_function: :sigmoid)
      ]
      connection_genes = [
        Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 0.6, innovation_number: 1, enabled: true),
        Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 3, weight: 0.6, innovation_number: 2, enabled: true),
        Morf::NEAT::ConnectionGene.new(in_node_id: 3, out_node_id: 2, weight: 0.6, innovation_number: 3, enabled: true)
      ]
      Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: connection_genes)
    end

    let(:genome4) do
      # a genome that is different from the others
      node_genes = [
        Morf::NEAT::NodeGene.new(id: 1, type: :input, activation_function: :identity),
        Morf::NEAT::NodeGene.new(id: 2, type: :output, activation_function: :sigmoid),
        Morf::NEAT::NodeGene.new(id: 4, type: :hidden, activation_function: :sigmoid)
      ]
      connection_genes = [
        Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 4, weight: 0.5, innovation_number: 5, enabled: true),
        Morf::NEAT::ConnectionGene.new(in_node_id: 4, out_node_id: 2, weight: 0.5, innovation_number: 6, enabled: true)
      ]
      Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: connection_genes)
    end

    let(:population) { [genome1, genome2, genome3, genome4] }

    it "groups genomes into species" do
      species = speciation.speciate

      aggregate_failures do
        expect(species.length).to eq(2)
        expect(species[0]).to include(genome1, genome2, genome3)
        expect(species[1]).to include(genome4)
      end
    end
  end
end
