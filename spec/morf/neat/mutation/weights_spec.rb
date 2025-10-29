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
      mutation_strategy: mutation_strategy
    )
  end

  let(:mutation_strategy) { double("MutationStrategy") }
  let(:genome) { Morf::NEAT::Genome.new(node_genes: [], connection_genes: connection_genes) }
  let(:connection_genes) do
    [
      Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 0.5, innovation_number: 1, enabled: true)
    ]
  end

  describe "#call" do
    it "mutates each connection weight using the strategy" do
      allow(mutation_strategy).to receive(:mutate_weight).with(0.5).and_return(0.8)

      mutation.call

      aggregate_failures do
        expect(mutation_strategy).to have_received(:mutate_weight).with(0.5)
        expect(genome.connection_genes.first.weight).to eq(0.8)
      end
    end
  end
end
