# frozen_string_literal: true

require "spec_helper"
require "morf/neat/reproduction"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::Reproduction do
  subject(:reproduction) { described_class.new(random: random) }

  let(:random) { instance_double(Random, rand: 0) }

  let(:node_genes) do
    [
      Morf::NEAT::NodeGene.new(id: 1, type: :input, activation_function: :identity),
      Morf::NEAT::NodeGene.new(id: 2, type: :output, activation_function: :sigmoid)
    ]
  end

  let(:connection_genes1) do
    [
      Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 0.5, innovation_number: 1, enabled: true)
    ]
  end

  let(:connection_genes2) do
    [
      Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 1.0, innovation_number: 1, enabled: true)
    ]
  end

  let(:parent1) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: connection_genes1) }
  let(:parent2) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: connection_genes2) }

  describe "#crossover" do
    context "with identical parents" do
      let(:connection_genes2) { connection_genes1 }

      it "creates a child identical to the parents" do
        child = reproduction.crossover(parent1, parent2, 1.0, 1.0)

        aggregate_failures do
          expect(child.node_genes).to match_array(parent1.node_genes)
          expect(child.connection_genes).to match_array(parent1.connection_genes)
        end
      end
    end

    context "with parents with different connection weights" do
      it "creates a child with a connection from the first parent" do
        allow(random).to receive(:rand).and_return(0)
        child = reproduction.crossover(parent1, parent2, 1.0, 1.0)

        expect(child.connection_genes.first).to eq(connection_genes1.first)
      end

      it "creates a child with a connection from the second parent" do
        allow(random).to receive(:rand).and_return(1)
        child = reproduction.crossover(parent1, parent2, 1.0, 1.0)

        expect(child.connection_genes.first).to eq(connection_genes2.first)
      end
    end

    context "with disjoint and excess genes from the more fit parent" do
      let(:connection_genes1) do
        [
          Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 0.5, innovation_number: 1, enabled: true),
          Morf::NEAT::ConnectionGene.new(in_node_id: 2, out_node_id: 3, weight: 0.5, innovation_number: 2, enabled: true) # disjoint
        ]
      end

      let(:connection_genes2) do
        [
          Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 1.0, innovation_number: 1, enabled: true),
          Morf::NEAT::ConnectionGene.new(in_node_id: 2, out_node_id: 4, weight: 0.5, innovation_number: 3, enabled: true), # disjoint
          Morf::NEAT::ConnectionGene.new(in_node_id: 3, out_node_id: 4, weight: 0.5, innovation_number: 4, enabled: true) # excess
        ]
      end

      it "inherits disjoint genes from parent1" do
        child = reproduction.crossover(parent1, parent2, 2.0, 1.0)
        expect(child.connection_genes.map(&:innovation_number)).to include(2)
      end

      it "does not inherit genes from parent2" do
        child = reproduction.crossover(parent1, parent2, 2.0, 1.0)
        expect(child.connection_genes.map(&:innovation_number)).not_to include(3, 4)
      end

      it "does not inherit genes from parent1" do
        child = reproduction.crossover(parent1, parent2, 1.0, 2.0)
        expect(child.connection_genes.map(&:innovation_number)).not_to include(2)
      end

      it "inherits disjoint and excess genes from parent2" do
        child = reproduction.crossover(parent1, parent2, 1.0, 2.0)
        expect(child.connection_genes.map(&:innovation_number)).to include(3, 4)
      end
    end
  end
end
