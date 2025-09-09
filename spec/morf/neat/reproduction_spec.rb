# frozen_string_literal: true

require "spec_helper"
require "morf/neat/reproduction"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"
require "morf/neat/mutation/mutator"

RSpec.describe Morf::NEAT::Reproduction do
  let(:reproduction) do
    described_class.new(
      random: random,
      next_node_id: 3,
      next_innovation_number: 2
    )
  end

  let(:random) { instance_double(Random, rand: 0) }
  let(:genome) { Morf::NEAT::Genome.new(node_genes: [], connection_genes: []) }
  let(:mutator_instance) { instance_double(Morf::NEAT::Mutation::Mutator, mutate: nil, next_node_id: 4, next_innovation_number: 5) }

  before do
    allow(Morf::NEAT::Mutation::Mutator).to receive(:new).and_return(mutator_instance)
  end

  describe "#mutate" do
    it "delegates to the mutator" do
      reproduction.mutate(genome)
      expect(mutator_instance).to have_received(:mutate).with(genome)
    end
  end

  describe "#next_node_id" do
    it "delegates to the mutator" do
      expect(reproduction.next_node_id).to eq(4)
    end
  end

  describe "#next_innovation_number" do
    it "delegates to the mutator" do
      expect(reproduction.next_innovation_number).to eq(5)
    end
  end
end
