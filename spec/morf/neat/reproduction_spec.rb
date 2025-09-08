# frozen_string_literal: true

require "spec_helper"
require "morf/neat/reproduction"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::Reproduction do
  let(:reproduction) do
    described_class.new(
      random: random,
      next_node_id: 3,
      next_innovation_number: 2,
      weight_range: -4.0..4.0,
      new_weight_probability: 0.1
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
      Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 3.95, innovation_number: 1, enabled: true)
    ]
  end

  let(:genome) { Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: connection_genes) }

  describe "#mutate_add_node" do
    before do
      connection_genes.first.weight = 0.5
      reproduction.mutate_add_node(genome)
    end

    it "adds a new hidden node" do
      aggregate_failures do
        expect(genome.node_genes.count).to eq(4)
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
  end

  describe "#mutate_add_connection" do
    it "adds a new connection" do
      allow(random).to receive(:rand).with(-1.0..1.0).and_return(0.75)
      # Force sample to return two unconnected nodes
      allow(genome.node_genes).to receive(:sample).and_return([node_genes[0], node_genes[2]])

      reproduction.mutate_add_connection(genome)

      aggregate_failures do
        expect(genome.connection_genes.count).to eq(2)
        new_conn = genome.connection_genes.last
        expect(new_conn.in_node_id).to eq(1)
        expect(new_conn.out_node_id).to eq(3)
        expect(new_conn.weight).to eq(0.75)
        expect(new_conn.innovation_number).to eq(2)
      end
    end

    context "when a connection already exists" do
      it "does not add a new connection" do
        # Force sample to return the two nodes that are already connected
        allow(genome.node_genes).to receive(:sample).and_return([node_genes[0], node_genes[1]])

        reproduction.mutate_add_connection(genome)
        expect(genome.connection_genes.count).to eq(1)
      end

      it "retries if it fails to find an unconnected pair" do
        # First, return a connected pair, then an unconnected one.
        allow(genome.node_genes).to receive(:sample).and_return(
          [node_genes[0], node_genes[1]],
          [node_genes[0], node_genes[2]]
        )
        allow(random).to receive(:rand).with(-1.0..1.0).and_return(0.75)

        reproduction.mutate_add_connection(genome)
        expect(genome.connection_genes.count).to eq(2)
      end
    end
  end

  describe "#mutate_weights" do
    context "when perturbing a weight" do
      it "updates the weight of a connection" do
        connection_genes.first.weight = 0.5
        allow(random).to receive(:rand).and_return(0.5)
        allow(random).to receive(:rand).with(-0.1..0.1).and_return(0.05)

        reproduction.mutate_weights(genome)
        expect(genome.connection_genes.first.weight).to be_within(0.001).of(0.55)
      end

      it "clamps the weight to the max value" do
        allow(random).to receive(:rand).and_return(0.5)
        allow(random).to receive(:rand).with(-0.1..0.1).and_return(0.1)

        reproduction.mutate_weights(genome)
        expect(genome.connection_genes.first.weight).to eq(4.0)
      end
    end

    context "when assigning a new weight" do
      it "updates the weight of a connection" do
        allow(random).to receive(:rand).and_return(0.05)
        allow(random).to receive(:rand).with(-1.0..1.0).and_return(0.8)

        reproduction.mutate_weights(genome)
        expect(genome.connection_genes.first.weight).to be_within(0.001).of(0.8)
      end
    end
  end

  describe "#mutate" do
    context "with add_node mutation" do
      it "calls mutate_add_node" do
        allow(random).to receive(:rand).and_return(0.02)
        allow(reproduction).to receive(:mutate_add_node)

        reproduction.mutate(genome)

        expect(reproduction).to have_received(:mutate_add_node).with(genome)
      end
    end

    context "with add_connection mutation" do
      it "calls mutate_add_connection" do
        allow(random).to receive(:rand).and_return(0.04)
        allow(reproduction).to receive(:mutate_add_connection)

        reproduction.mutate(genome)

        expect(reproduction).to have_received(:mutate_add_connection).with(genome)
      end
    end

    context "with mutate_weights mutation" do
      it "calls mutate_weights" do
        allow(random).to receive(:rand).and_return(0.5)
        allow(reproduction).to receive(:mutate_weights)

        reproduction.mutate(genome)

        expect(reproduction).to have_received(:mutate_weights).with(genome)
      end
    end
  end
end
