# frozen_string_literal: true

require "spec_helper"
require "morf/neat/mutation/add_connection"
require "morf/neat/genome"
require "morf/neat/node_gene"

RSpec.describe Morf::NEAT::Mutation::AddConnection do
  subject(:mutator) do
    described_class.new(
      genome,
      random: Random.new,
      next_innovation_number: 1,
      max_attempts: 1
    )
  end

  let(:input_node) { Morf::NEAT::NodeGene.new(id: 0, type: :input, activation_function: :identity) }
  let(:output_node) { Morf::NEAT::NodeGene.new(id: 1, type: :output, activation_function: :identity) }
  let(:nodes) { [input_node, output_node] }
  let(:genome) { Morf::NEAT::Genome.new(node_genes: nodes, connection_genes: []) }

  context "when attempting to create a recurrent connection" do
    it "rejects a connection from an output node to an input node" do
      # Force the mutator to pick output -> input
      allow(genome.node_genes).to receive(:sample).and_return([output_node, input_node])

      mutator.call

      # The mutator should swap them and create a valid input -> output connection
      aggregate_failures do
        expect(genome.connection_genes.size).to eq(1)
        expect(genome.connection_genes.first.in_node_id).to eq(input_node.id)
        expect(genome.connection_genes.first.out_node_id).to eq(output_node.id)
      end
    end

    it "rejects a connection from a hidden node to an input node" do
      hidden_node = Morf::NEAT::NodeGene.new(id: 2, type: :hidden, activation_function: :identity)
      genome.add_node_gene(hidden_node)
      allow(genome.node_genes).to receive(:sample).and_return([hidden_node, input_node])

      mutator.call

      # The mutator should swap them and create a valid input -> hidden connection
      aggregate_failures do
        expect(genome.connection_genes.size).to eq(1)
        expect(genome.connection_genes.first.in_node_id).to eq(input_node.id)
        expect(genome.connection_genes.first.out_node_id).to eq(hidden_node.id)
      end
    end

    it "rejects a connection from an output node to a hidden node" do
      hidden_node = Morf::NEAT::NodeGene.new(id: 2, type: :hidden, activation_function: :identity)
      genome.add_node_gene(hidden_node)
      allow(genome.node_genes).to receive(:sample).and_return([output_node, hidden_node])

      mutator.call

      # The mutator should swap them and create a valid hidden -> output connection
      aggregate_failures do
        expect(genome.connection_genes.size).to eq(1)
        expect(genome.connection_genes.first.in_node_id).to eq(hidden_node.id)
        expect(genome.connection_genes.first.out_node_id).to eq(output_node.id)
      end
    end

    it "rejects a connection between two input nodes" do
      input_node2 = Morf::NEAT::NodeGene.new(id: 2, type: :input, activation_function: :identity)
      genome.add_node_gene(input_node2)
      allow(genome.node_genes).to receive(:sample).and_return([input_node, input_node2])

      expect { mutator.call }.not_to(change { genome.connection_genes.size })
    end

    it "rejects a connection that would create a cycle between hidden nodes" do
      hidden1 = Morf::NEAT::NodeGene.new(id: 2, type: :hidden, activation_function: :identity)
      hidden2 = Morf::NEAT::NodeGene.new(id: 3, type: :hidden, activation_function: :identity)
      genome.add_node_gene(hidden1)
      genome.add_node_gene(hidden2)
      # Create a path: input -> hidden1 -> hidden2 -> output
      genome.add_connection_gene(Morf::NEAT::ConnectionGene.new(in_node_id: 0, out_node_id: 2, weight: 1.0, enabled: true, innovation_number: 10))
      genome.add_connection_gene(Morf::NEAT::ConnectionGene.new(in_node_id: 2, out_node_id: 3, weight: 1.0, enabled: true, innovation_number: 11))
      genome.add_connection_gene(Morf::NEAT::ConnectionGene.new(in_node_id: 3, out_node_id: 1, weight: 1.0, enabled: true, innovation_number: 12))

      # Force the mutator to pick hidden2 -> hidden1, which would create a cycle
      allow(genome.node_genes).to receive(:sample).and_return([hidden2, hidden1])

      expect { mutator.call }.not_to(change { genome.connection_genes.size })
    end

    it "ignores disabled connections when checking for cycles" do
      hidden1 = Morf::NEAT::NodeGene.new(id: 2, type: :hidden, activation_function: :identity)
      hidden2 = Morf::NEAT::NodeGene.new(id: 3, type: :hidden, activation_function: :identity)
      genome.add_node_gene(hidden1)
      genome.add_node_gene(hidden2)
      # Create a disabled path: hidden1 -> hidden2
      genome.add_connection_gene(Morf::NEAT::ConnectionGene.new(in_node_id: 2, out_node_id: 3, weight: 1.0, enabled: false, innovation_number: 11))

      # Force the mutator to pick hidden2 -> hidden1. This should be allowed as the path is disabled.
      allow(genome.node_genes).to receive(:sample).and_return([hidden2, hidden1])

      expect { mutator.call }.to change { genome.connection_genes.size }.by(1)
    end
  end
end
