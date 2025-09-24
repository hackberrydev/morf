# frozen_string_literal: true

require "spec_helper"
require "morf/neat/reproduction"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::Reproduction do
  subject(:reproduction) { described_class.new }

  let(:node_genes) do
    [
      Morf::NEAT::NodeGene.new(id: 0, type: :input, activation_function: :identity),
      Morf::NEAT::NodeGene.new(id: 1, type: :output, activation_function: :identity)
    ]
  end
  let(:conn_gene) { Morf::NEAT::ConnectionGene.new(in_node_id: 0, out_node_id: 1, weight: 0.5, enabled: true, innovation_number: 0) }
  let(:parent1) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: [conn_gene]) }
  let(:parent2) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: [conn_gene.clone]) }

  describe "#crossover" do
    let(:child) { reproduction.crossover(parent1, parent2, 1.0, 1.0) }

    it "creates a child with deep-copied node genes" do
      expect(child.node_genes.first.object_id).not_to eq(parent1.node_genes.first.object_id)
    end

    it "creates a child with deep-copied connection genes" do
      expect(child.connection_genes.first.object_id).not_to eq(parent1.connection_genes.first.object_id)
    end
  end
end
