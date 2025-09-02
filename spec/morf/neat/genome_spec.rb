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
end
