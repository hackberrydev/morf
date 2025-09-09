# frozen_string_literal: true

require "spec_helper"
require "morf/neat/mutation/add_connection"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::Mutation::AddConnection do
  subject(:mutation) do
    described_class.new(
      genome,
      random: random,
      next_innovation_number: 2,
      max_attempts: 10
    )
  end

  let(:random) { instance_double(Random, rand: 0) }

  let(:node_genes) do
    [
      Morf::NEAT::NodeGene.new(id: 1, type: :input, activation_function: :identity),
      Morf::NEAT::NodeGene.new(id: 2, type: :output, activation_function: :sigmoid),
      Morf::NEAT::NodeGene.new(id: 3, type: :hidden, activation_function: :sigmoid)
    ]
  end

  let(:connection_genes) do
    [
      Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 0.5, innovation_number: 1, enabled: true)
    ]
  end

  let(:genome) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: connection_genes) }

  describe "#call" do
    it "adds a new connection" do
      allow(random).to receive(:rand).with(-1.0..1.0).and_return(0.75)
      allow(genome.node_genes).to receive(:sample).and_return([node_genes[0], node_genes[2]])

      result = mutation.call

      aggregate_failures do
        expect(genome.connection_genes.count).to eq(2)
        new_conn = genome.connection_genes.last
        expect(new_conn.in_node_id).to eq(1)
        expect(new_conn.out_node_id).to eq(3)
        expect(new_conn.weight).to eq(0.75)
        expect(new_conn.innovation_number).to eq(2)
        expect(result).to eq({next_innovation_number: 3})
      end
    end

    context "when a connection already exists" do
      it "does not add a new connection" do
        aggregate_failures do
          allow(genome.node_genes).to receive(:sample).and_return([node_genes[0], node_genes[1]])

          result = mutation.call
          expect(genome.connection_genes.count).to eq(1)
          expect(result).to be_nil
        end
      end

      it "retries if it fails to find an unconnected pair" do
        allow(genome.node_genes).to receive(:sample).and_return(
          [node_genes[0], node_genes[1]],
          [node_genes[0], node_genes[2]]
        )
        allow(random).to receive(:rand).with(-1.0..1.0).and_return(0.75)

        mutation.call
        expect(genome.connection_genes.count).to eq(2)
      end
    end
  end
end
