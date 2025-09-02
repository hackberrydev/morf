# frozen_string_literal: true

require "spec_helper"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::Genome do
  subject(:genome) { described_class.new(node_genes: node_genes, connection_genes: connection_genes) }

  let(:node_genes) do
    [
      Morf::NEAT::NodeGene.new(id: 1, type: :input, activation_function: :identity),
      Morf::NEAT::NodeGene.new(id: 2, type: :output, activation_function: :sigmoid)
    ]
  end
  let(:connection_genes) do
    [
      Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 0.5, enabled: true, innovation_number: 1)
    ]
  end

  it "has node genes" do
    expect(genome.node_genes).to eq(node_genes)
  end

  it "has connection genes" do
    expect(genome.connection_genes).to eq(connection_genes)
  end

  describe "#add_node_gene" do
    let(:new_node_gene) { Morf::NEAT::NodeGene.new(id: 3, type: :hidden, activation_function: :relu) }

    it "adds a node gene to the genome" do
      genome.add_node_gene(new_node_gene)
      expect(genome.node_genes).to include(new_node_gene)
    end
  end

  describe "#add_connection_gene" do
    let(:new_connection_gene) { Morf::NEAT::ConnectionGene.new(in_node_id: 2, out_node_id: 3, weight: 0.8, enabled: true, innovation_number: 2) }

    it "adds a connection gene to the genome" do
      genome.add_connection_gene(new_connection_gene)
      expect(genome.connection_genes).to include(new_connection_gene)
    end
  end
end
