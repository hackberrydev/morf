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

    context "when parents have different topologies" do
      let(:p1_nodes) do
        [
          Morf::NEAT::NodeGene.new(id: 0, type: :input, activation_function: :identity),
          Morf::NEAT::NodeGene.new(id: 1, type: :output, activation_function: :identity)
        ]
      end
      let(:p1_conn) { Morf::NEAT::ConnectionGene.new(in_node_id: 0, out_node_id: 1, weight: 0.5, enabled: true, innovation_number: 0) }
      let(:parent1) { Morf::NEAT::Genome.new(node_genes: p1_nodes, connection_genes: [p1_conn]) }

      let(:p2_nodes) do
        [
          Morf::NEAT::NodeGene.new(id: 0, type: :input, activation_function: :identity),
          Morf::NEAT::NodeGene.new(id: 1, type: :output, activation_function: :identity),
          Morf::NEAT::NodeGene.new(id: 2, type: :hidden, activation_function: :identity)
        ]
      end
      let(:p2_conn1) { Morf::NEAT::ConnectionGene.new(in_node_id: 0, out_node_id: 1, weight: 0.5, enabled: true, innovation_number: 0) }
      let(:p2_conn2) { Morf::NEAT::ConnectionGene.new(in_node_id: 0, out_node_id: 2, weight: 0.5, enabled: true, innovation_number: 1) }
      let(:parent2) { Morf::NEAT::Genome.new(node_genes: p2_nodes, connection_genes: [p2_conn1, p2_conn2]) }

      it "includes genes correctly when parent2 is more fit" do
        child = reproduction.crossover(parent1, parent2, 1.0, 2.0)
        aggregate_failures do
          expect(child.node_genes.map(&:id)).to contain_exactly(0, 1, 2)
          expect(child.connection_genes.map(&:innovation_number)).to include(1)
        end
      end

      it "includes genes correctly when parent1 is more fit" do
        child = reproduction.crossover(parent1, parent2, 2.0, 1.0)
        aggregate_failures do
          expect(child.node_genes.map(&:id)).to contain_exactly(0, 1, 2)
          expect(child.connection_genes.map(&:innovation_number)).not_to include(1)
        end
      end
    end
  end
end
