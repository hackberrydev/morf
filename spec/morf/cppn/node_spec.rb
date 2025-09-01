# frozen_string_literal: true

require "spec_helper"
require "morf/cppn/node"
require "morf/cppn/connection"
require "morf/cppn/activation_functions"

RSpec.describe Morf::CPPN::Node do
  subject(:node) { described_class.new(id: 1, layer: :input, activation_function: :sigmoid) }

  it "has an id" do
    expect(node.id).to eq(1)
  end

  it "has a layer" do
    expect(node.layer).to eq(:input)
  end

  it "has an activation function" do
    expect(node.activation_function).to eq(:sigmoid)
  end

  describe "#calculate" do
    subject(:calculate) { node.calculate }

    let(:input_node1) { described_class.new(id: 2, layer: :input, activation_function: :identity) }
    let(:input_node2) { described_class.new(id: 3, layer: :input, activation_function: :identity) }

    before do
      input_node1.input = 0.5
      input_node2.input = 0.5
    end

    context "when node is an input node" do
      let(:node) { input_node1 }

      it "returns the cached value" do
        expect(calculate).to eq(0.5)
      end
    end

    context "when node is not an input node" do
      let(:node) { described_class.new(id: 4, layer: :output, activation_function: :sigmoid) }

      it "calculates the weighted sum and applies the activation function when node has incomming connections" do
        connection1 = Morf::CPPN::Connection.new(input_node: input_node1, output_node: node, weight: 0.5)
        connection2 = Morf::CPPN::Connection.new(input_node: input_node2, output_node: node, weight: 0.5)

        node.add_incoming_connection(connection1)
        node.add_incoming_connection(connection2)

        expected_output = Morf::CPPN::ActivationFunctions.sigmoid(0.5 * 0.5 + 0.5 * 0.5)
        expect(calculate).to be_within(0.01).of(expected_output)
      end

      it "returns the activation function of 0 when node has no incoming connections" do
        expected_output = Morf::CPPN::ActivationFunctions.sigmoid(0)
        expect(calculate).to eq(expected_output)
      end
    end
  end

  describe "#input?" do
    it "returns true when node is an input node" do
      node = described_class.new(id: 1, layer: :input, activation_function: :identity)

      expect(node.input?).to be true
    end

    it "returns false when node is not an input node" do
      node = described_class.new(id: 1, layer: :output, activation_function: :identity)

      expect(node.input?).to be false
    end
  end

  describe "#output?" do
    it "returns true when node is an output node" do
      node = described_class.new(id: 1, layer: :output, activation_function: :identity)

      expect(node.output?).to be true
    end

    it "returns false when node is not an output node" do
      node = described_class.new(id: 1, layer: :input, activation_function: :identity)

      expect(node.output?).to be false
    end
  end
end
