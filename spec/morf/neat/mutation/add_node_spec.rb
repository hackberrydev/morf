# frozen_string_literal: true

require "spec_helper"
require "morf/neat/mutation/add_node"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::Mutation::AddNode do
  subject(:mutation) do
    described_class.new(
      genome,
      mutation_strategy: mutation_strategy,
      next_node_id: 3,
      next_innovation_number: 2
    )
  end

  let(:mutation_strategy) { double("MutationStrategy") }

  let(:node_genes) do
    [
      Morf::NEAT::NodeGene.new(id: 1, type: :input, activation_function: :identity),
      Morf::NEAT::NodeGene.new(id: 2, type: :output, activation_function: :sigmoid)
    ]
  end

  let(:connection_genes) do
    [
      Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 0.5, innovation_number: 1, enabled: true)
    ]
  end

  let(:genome) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: connection_genes) }

  describe "#call" do
    let(:result) { mutation.call }

    before do
      allow(mutation_strategy).to receive_messages(
        random_connection: connection_genes.first,
        random_activation_function: :sigmoid
      )
      result
    end

    it "adds a new hidden node" do
      aggregate_failures do
        expect(genome.node_genes.count).to eq(3)
        expect(genome.node_genes.last.id).to eq(3)
        expect(genome.node_genes.last.type).to eq(:hidden)
      end
    end

    it "adds two new connections and disables the old one" do
      aggregate_failures do
        expect(genome.connection_genes.count).to eq(3)
        expect(genome.connection_genes[0].enabled).to be(false)

        new_conn1 = genome.connection_genes[1]
        expect(new_conn1.in_node_id).to eq(1)
        expect(new_conn1.out_node_id).to eq(3)
        expect(new_conn1.weight).to eq(1.0)
        expect(new_conn1.innovation_number).to eq(2)

        new_conn2 = genome.connection_genes[2]
        expect(new_conn2.in_node_id).to eq(3)
        expect(new_conn2.out_node_id).to eq(2)
        expect(new_conn2.weight).to eq(0.5)
        expect(new_conn2.innovation_number).to eq(3)
      end
    end

    it "returns the next available node id and innovation number" do
      expect(result).to eq({next_node_id: 4, next_innovation_number: 4})
    end
  end
end
