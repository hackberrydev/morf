# frozen_string_literal: true

require "spec_helper"
require "morf/neat/mutation/weights"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::Mutation::Weights do
  subject(:mutation) do
    described_class.new(
      genome,
      random: random,
      new_weight_prob: 0.1,
      weight_range: -4.0..4.0
    )
  end

  let(:random) { instance_double(Random, rand: 0) }
  let(:genome) { Morf::NEAT::Genome.new(node_genes: [], connection_genes: connection_genes) }
  let(:connection_genes) do
    [
      Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 3.95, innovation_number: 1, enabled: true)
    ]
  end

  describe "#call" do
    context "when perturbing a weight" do
      it "updates the weight of a connection" do
        connection_genes.first.weight = 0.5
        allow(random).to receive(:rand).and_return(0.5)
        allow(random).to receive(:rand).with(-0.1..0.1).and_return(0.05)

        mutation.call
        expect(genome.connection_genes.first.weight).to be_within(0.001).of(0.55)
      end

      it "clamps the weight to the max value" do
        allow(random).to receive(:rand).and_return(0.5)
        allow(random).to receive(:rand).with(-0.1..0.1).and_return(0.1)

        mutation.call
        expect(genome.connection_genes.first.weight).to eq(4.0)
      end
    end

    context "when assigning a new weight" do
      it "updates the weight of a connection" do
        allow(random).to receive(:rand).and_return(0.05)
        allow(random).to receive(:rand).with(-1.0..1.0).and_return(0.8)

        mutation.call
        expect(genome.connection_genes.first.weight).to be_within(0.001).of(0.8)
      end
    end
  end
end
