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

  describe "#duel" do
    let(:parent1_conn) do
      Morf::NEAT::ConnectionGene.new(in_node_id: 0, out_node_id: 1, weight: 1.0, enabled: true, innovation_number: 0)
    end
    let(:parent2_conn) do
      Morf::NEAT::ConnectionGene.new(in_node_id: 0, out_node_id: 1, weight: 2.0, enabled: true, innovation_number: 0)
    end
    let(:parent1) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: [parent1_conn]) }
    let(:parent2) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: [parent2_conn]) }

    before do
      parent1.fitness = fitness1
      parent2.fitness = fitness2
    end

    context "when parent1 has higher fitness" do
      let(:fitness1) { 10.0 }
      let(:fitness2) { 5.0 }

      it "returns a clone of the winner" do
        aggregate_failures do
          winner = reproduction.duel(parent1, parent2)
          expect(winner).to be_a(Morf::NEAT::Genome)
          expect(winner).not_to be(parent1)
          expect(winner).not_to be(parent2)
        end
      end

      it "parent1 wins more frequently" do
        winners = Array.new(1000) { reproduction.duel(parent1, parent2) }
        parent1_wins = winners.count { |w| (w.connection_genes.first.weight - 1.0).abs < 0.001 }
        expect(parent1_wins).to be > 600
      end
    end

    context "when parent2 has higher fitness" do
      let(:fitness1) { 3.0 }
      let(:fitness2) { 12.0 }

      it "parent2 wins more frequently" do
        winners = Array.new(1000) { reproduction.duel(parent1, parent2) }
        parent2_wins = winners.count { |w| (w.connection_genes.first.weight - 2.0).abs < 0.001 }
        expect(parent2_wins).to be > 700
      end
    end

    context "when both parents have equal fitness" do
      let(:fitness1) { 5.0 }
      let(:fitness2) { 5.0 }

      it "both parents win with approximately equal probability" do
        winners = Array.new(1000) { reproduction.duel(parent1, parent2) }
        parent1_wins = winners.count { |w| (w.connection_genes.first.weight - 1.0).abs < 0.001 }
        expect(parent1_wins).to be_between(400, 600)
      end
    end

    context "when both parents have zero or negative fitness" do
      let(:fitness1) { 0.0 }
      let(:fitness2) { 0.0 }

      it "randomly picks a winner" do
        winner = reproduction.duel(parent1, parent2)
        expect(winner).to be_a(Morf::NEAT::Genome)
      end
    end
  end
end
