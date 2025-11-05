# frozen_string_literal: true

require "spec_helper"
require "morf/neat/reproduction/crossover"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::Reproduction::Crossover do
  subject(:crossover) { described_class.new }

  let(:node_genes) do
    [
      Morf::NEAT::NodeGene.new(id: 0, type: :input, activation_function: :identity),
      Morf::NEAT::NodeGene.new(id: 1, type: :output, activation_function: :identity)
    ]
  end
  let(:conn_gene) { Morf::NEAT::ConnectionGene.new(in_node_id: 0, out_node_id: 1, weight: 0.5, enabled: true, innovation_number: 0) }
  let(:parent1) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: [conn_gene]) }
  let(:parent2) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: [conn_gene.clone]) }

  before do
    parent1.fitness = 1.0
    parent2.fitness = 1.0
  end

  describe "#reproduce" do
    let(:child) { crossover.reproduce(parent1, parent2) }

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

      let(:p1_conn) do
        Morf::NEAT::ConnectionGene.new(
          in_node_id: 0, out_node_id: 1, weight: 0.5, enabled: true, innovation_number: 0
        )
      end

      let(:parent1) { Morf::NEAT::Genome.new(node_genes: p1_nodes, connection_genes: [p1_conn]) }

      let(:p2_nodes) do
        [
          Morf::NEAT::NodeGene.new(id: 0, type: :input, activation_function: :identity),
          Morf::NEAT::NodeGene.new(id: 1, type: :output, activation_function: :identity),
          Morf::NEAT::NodeGene.new(id: 2, type: :hidden, activation_function: :identity)
        ]
      end

      let(:p2_conn1) do
        Morf::NEAT::ConnectionGene.new(
          in_node_id: 0, out_node_id: 1, weight: 0.5, enabled: true, innovation_number: 0
        )
      end

      let(:p2_conn2) do
        Morf::NEAT::ConnectionGene.new(
          in_node_id: 0, out_node_id: 2, weight: 0.5, enabled: true, innovation_number: 1
        )
      end

      let(:parent2) do
        Morf::NEAT::Genome.new(node_genes: p2_nodes, connection_genes: [p2_conn1, p2_conn2])
      end

      it "includes genes from fitter parent when parent2 is more fit" do
        parent1.fitness = 1.0
        parent2.fitness = 2.0
        child = crossover.reproduce(parent1, parent2)
        aggregate_failures do
          expect(child.node_genes.map(&:id)).to contain_exactly(0, 1, 2)
          expect(child.connection_genes.map(&:innovation_number)).to include(1)
        end
      end

      it "excludes disjoint genes from less fit parent when parent1 is more fit" do
        parent1.fitness = 2.0
        parent2.fitness = 1.0
        child = crossover.reproduce(parent1, parent2)
        aggregate_failures do
          expect(child.node_genes.map(&:id)).to contain_exactly(0, 1, 2)
          expect(child.connection_genes.map(&:innovation_number)).not_to include(1)
        end
      end
    end
  end
end
