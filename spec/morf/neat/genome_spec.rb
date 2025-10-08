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

  describe "#clone" do
    let(:cloned_genome) { genome.clone }

    it "creates a new genome instance" do
      expect(cloned_genome).not_to be(genome)
    end

    it "creates new node_genes array" do
      expect(cloned_genome.node_genes).not_to be(genome.node_genes)
    end

    it "creates new connection_genes array" do
      expect(cloned_genome.connection_genes).not_to be(genome.connection_genes)
    end

    it "clones node genes" do
      expect(cloned_genome.node_genes.first).not_to be(genome.node_genes.first)
    end

    it "clones connection genes" do
      expect(cloned_genome.connection_genes.first).not_to be(genome.connection_genes.first)
    end

    it "preserves node gene attributes" do
      aggregate_failures do
        original_node = genome.node_genes.first
        cloned_node = cloned_genome.node_genes.first
        expect(cloned_node.id).to eq(original_node.id)
        expect(cloned_node.type).to eq(original_node.type)
        expect(cloned_node.activation_function).to eq(original_node.activation_function)
      end
    end

    it "preserves connection gene attributes" do
      aggregate_failures do
        original_conn = genome.connection_genes.first
        cloned_conn = cloned_genome.connection_genes.first
        expect(cloned_conn.in_node_id).to eq(original_conn.in_node_id)
        expect(cloned_conn.out_node_id).to eq(original_conn.out_node_id)
        expect(cloned_conn.weight).to eq(original_conn.weight)
        expect(cloned_conn.enabled).to eq(original_conn.enabled)
        expect(cloned_conn.innovation_number).to eq(original_conn.innovation_number)
      end
    end

    it "allows independent modification of connection gene weight" do
      original_weight = genome.connection_genes.first.weight
      cloned_genome.connection_genes.first.weight = 0.9
      expect(genome.connection_genes.first.weight).to eq(original_weight)
    end

    it "allows independent modification via disable method" do
      aggregate_failures do
        cloned_genome.connection_genes.first.disable
        expect(genome.connection_genes.first.enabled?).to be(true)
        expect(cloned_genome.connection_genes.first.enabled?).to be(false)
      end
    end
  end
end
