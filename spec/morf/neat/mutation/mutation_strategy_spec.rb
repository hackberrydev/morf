# frozen_string_literal: true

require "spec_helper"
require "morf/neat/mutation/mutation_strategy"
require "morf/cppn/activation_functions"

RSpec.describe Morf::NEAT::Mutation::MutationStrategy do
  let(:random) { instance_double(Random) }

  describe "#add_node?" do
    let(:config) do
      described_class.new(
        random: random,
        add_node_prob: 0.5
      )
    end

    context "when random value is below add_node_prob" do
      it "returns true" do
        allow(random).to receive(:rand).and_return(0.3)
        expect(config.add_node?).to be(true)
      end
    end

    context "when random value is equal to add_node_prob" do
      it "returns false" do
        allow(random).to receive(:rand).and_return(0.5)
        expect(config.add_node?).to be(false)
      end
    end

    context "when random value is above add_node_prob" do
      it "returns false" do
        allow(random).to receive(:rand).and_return(0.7)
        expect(config.add_node?).to be(false)
      end
    end
  end

  describe "#add_connection?" do
    let(:config) do
      described_class.new(
        random: random,
        add_connection_prob: 0.5
      )
    end

    context "when random value is below add_connection_prob" do
      it "returns true" do
        allow(random).to receive(:rand).and_return(0.3)
        expect(config.add_connection?).to be(true)
      end
    end

    context "when random value is equal to add_connection_prob" do
      it "returns false" do
        allow(random).to receive(:rand).and_return(0.5)
        expect(config.add_connection?).to be(false)
      end
    end

    context "when random value is above add_connection_prob" do
      it "returns false" do
        allow(random).to receive(:rand).and_return(0.7)
        expect(config.add_connection?).to be(false)
      end
    end
  end

  describe "#mutate_weights?" do
    let(:config) do
      described_class.new(
        random: random,
        weights_prob: 0.5
      )
    end

    context "when random value is below weights_prob" do
      it "returns true" do
        allow(random).to receive(:rand).and_return(0.3)
        expect(config.mutate_weights?).to be(true)
      end
    end

    context "when random value is equal to weights_prob" do
      it "returns false" do
        allow(random).to receive(:rand).and_return(0.5)
        expect(config.mutate_weights?).to be(false)
      end
    end

    context "when random value is above weights_prob" do
      it "returns false" do
        allow(random).to receive(:rand).and_return(0.7)
        expect(config.mutate_weights?).to be(false)
      end
    end
  end

  describe "#mutate_weight" do
    let(:config) do
      described_class.new(
        random: random,
        new_weight_prob: 0.5,
        weight_range: -4.0..4.0
      )
    end

    context "when random value is below new_weight_prob" do
      it "returns a new random weight" do
        allow(random).to receive(:rand).and_return(0.3, 0.5)
        result = config.mutate_weight(2.0)
        expect(result).to eq(0.5)
      end
    end

    context "when random value is equal to or above new_weight_prob" do
      it "returns the current weight perturbed" do
        allow(random).to receive(:rand).and_return(0.5, 0.05)
        result = config.mutate_weight(2.0)
        expect(result).to eq(2.05)
      end

      it "clamps the result to weight_range" do
        allow(random).to receive(:rand).and_return(0.6, 0.1)
        result = config.mutate_weight(4.0)
        expect(result).to eq(4.0)
      end
    end
  end

  describe "#random_node_pair" do
    let(:config) { described_class.new(random: random) }
    let(:nodes) { [1, 2, 3, 4, 5] }

    it "returns a pair of random nodes" do
      allow(random).to receive(:rand).and_return(0.2, 0.8)
      result = config.random_node_pair(nodes)
      aggregate_failures do
        expect(result).to be_an(Array)
        expect(result.size).to eq(2)
      end
    end
  end

  describe "#random_connection_weight" do
    let(:config) { described_class.new(random: random) }

    it "returns a random weight in range -1.0..1.0" do
      allow(random).to receive(:rand).with(-1.0..1.0).and_return(0.7)
      result = config.random_connection_weight
      expect(result).to eq(0.7)
    end
  end

  describe "#random_connection" do
    let(:config) { described_class.new(random: random) }
    let(:connections) { [1, 2, 3] }

    it "returns a random connection" do
      allow(random).to receive(:rand).and_return(0.5)
      result = config.random_connection(connections)
      expect(connections).to include(result)
    end
  end

  describe "#random_activation_function" do
    let(:config) { described_class.new(random: random) }

    it "returns a random activation function" do
      allow(Morf::CPPN::ActivationFunctions).to receive(:random).with(random: random).and_return(:sigmoid)
      result = config.random_activation_function
      expect(result).to eq(:sigmoid)
    end
  end
end
