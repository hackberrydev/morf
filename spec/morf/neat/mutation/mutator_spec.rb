# frozen_string_literal: true

require "spec_helper"
require "morf/neat/mutation/mutator"
require "morf/neat/mutation/mutation_strategy"
require "morf/neat/genome"
require "morf/neat/mutation/add_node"
require "morf/neat/mutation/add_connection"
require "morf/neat/mutation/weights"

RSpec.describe Morf::NEAT::Mutation::Mutator do
  subject(:mutator) do
    described_class.new(
      next_node_id: 3,
      next_innovation_number: 2,
      mutation_strategy: mutation_strategy
    )
  end

  let(:mutation_strategy) do
    Morf::NEAT::Mutation::MutationStrategy.new(
      random: random,
      add_node_prob: 0.5,
      add_connection_prob: 0.5,
      weights_prob: 0.5,
      new_weight_prob: 0.1,
      weight_range: -4.0..4.0,
      add_connection_max_attempts: 10
    )
  end
  let(:random) { instance_double(Random, rand: 1.0) }
  let(:genome) { instance_double(Morf::NEAT::Genome) }
  let(:add_node_mutation) { instance_double(Morf::NEAT::Mutation::AddNode, call: {next_node_id: 4, next_innovation_number: 4}) }
  let(:add_connection_mutation) { instance_double(Morf::NEAT::Mutation::AddConnection, call: {next_innovation_number: 3}) }
  let(:weights_mutation) { instance_double(Morf::NEAT::Mutation::Weights, call: nil) }

  before do
    allow(Morf::NEAT::Mutation::AddNode).to receive(:new).and_return(add_node_mutation)
    allow(Morf::NEAT::Mutation::AddConnection).to receive(:new).and_return(add_connection_mutation)
    allow(Morf::NEAT::Mutation::Weights).to receive(:new).and_return(weights_mutation)
  end

  describe "#mutate" do
    context "when add_node mutation is triggered" do
      it "calls the AddNode mutation and updates counters" do
        aggregate_failures do
          allow(random).to receive(:rand).and_return(0.4, 1.0, 1.0) # Trigger only add_node
          mutator.mutate(genome)

          expect(Morf::NEAT::Mutation::AddNode).to have_received(:new).with(genome, mutation_strategy: mutation_strategy, next_node_id: 3, next_innovation_number: 2)
          expect(add_node_mutation).to have_received(:call)
          expect(mutator.next_node_id).to eq(4)
          expect(mutator.next_innovation_number).to eq(4)
        end
      end
    end

    context "when add_connection mutation is triggered" do
      it "calls the AddConnection mutation and updates counters" do
        aggregate_failures do
          allow(random).to receive(:rand).and_return(1.0, 0.4, 1.0) # Trigger only add_connection
          mutator.mutate(genome)

          expect(Morf::NEAT::Mutation::AddConnection).to have_received(:new).with(genome, mutation_strategy: mutation_strategy, next_innovation_number: 2)
          expect(add_connection_mutation).to have_received(:call)
          expect(mutator.next_innovation_number).to eq(3)
        end
      end
    end

    context "when weights mutation is triggered" do
      it "calls the Weights mutation" do
        aggregate_failures do
          allow(random).to receive(:rand).and_return(1.0, 1.0, 0.4) # Trigger only weights
          mutator.mutate(genome)

          expect(Morf::NEAT::Mutation::Weights).to have_received(:new)
          expect(weights_mutation).to have_received(:call)
        end
      end
    end

    context "when no mutation is triggered" do
      it "does not call any mutation" do
        aggregate_failures do
          allow(random).to receive(:rand).and_return(1.0, 1.0, 1.0)
          mutator.mutate(genome)

          expect(add_node_mutation).not_to have_received(:call)
          expect(add_connection_mutation).not_to have_received(:call)
          expect(weights_mutation).not_to have_received(:call)
        end
      end
    end
  end
end
