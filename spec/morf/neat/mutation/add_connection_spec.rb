# frozen_string_literal: true

require "spec_helper"
require "morf/neat/mutation/add_connection"
require "morf/neat/mutation/mutation_strategy"
require "morf/neat/genome"
require "morf/neat/node_gene"

RSpec.describe Morf::NEAT::Mutation::AddConnection do
  subject(:mutator) do
    described_class.new(
      genome,
      mutation_strategy: mutation_strategy,
      next_innovation_number: 1
    )
  end

  let(:mutation_strategy) do
    double("MutationStrategy", add_connection_max_attempts: 1)
  end
  let(:input_node) { Morf::NEAT::NodeGene.new(id: 0, type: :input, activation_function: :identity) }
  let(:output_node) { Morf::NEAT::NodeGene.new(id: 1, type: :output, activation_function: :identity) }
  let(:nodes) { [input_node, output_node] }
  let(:genome) { Morf::NEAT::Genome.new(node_genes: nodes, connection_genes: []) }

  context "when attempting to create a recurrent connection" do
    it "rejects a connection from an output node to an input node" do
      # Force the mutator to pick output -> input
      allow(mutation_strategy).to receive_messages(
        random_node_pair: [output_node, input_node],
        random_connection_weight: 0.5
      )

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
      allow(mutation_strategy).to receive_messages(
        random_node_pair: [hidden_node, input_node],
        random_connection_weight: 0.5
      )

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
      allow(mutation_strategy).to receive_messages(
        random_node_pair: [output_node, hidden_node],
        random_connection_weight: 0.5
      )

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
      allow(mutation_strategy).to receive(:random_node_pair).and_return([input_node, input_node2])

      expect { mutator.call }.not_to(change { genome.connection_genes.size })
    end
  end
end
