# frozen_string_literal: true

require "spec_helper"
require "morf/cppn/node"
require "morf/cppn/connection"
require "morf/cppn/network"
require "morf/cppn/activation_functions"

RSpec.describe Morf::CPPN::Network do
  subject(:network) { described_class.new(nodes: nodes, connections: connections) }

  let(:input_node1) { Morf::CPPN::Node.new(id: 1, layer: :input, activation_function: :identity) }
  let(:input_node2) { Morf::CPPN::Node.new(id: 2, layer: :input, activation_function: :identity) }
  let(:output_node) { Morf::CPPN::Node.new(id: 3, layer: :output, activation_function: :sigmoid) }
  let(:nodes) { [input_node1, input_node2, output_node] }
  let(:connections) do
    [
      Morf::CPPN::Connection.new(input_node: input_node1, output_node: output_node, weight: 0.5),
      Morf::CPPN::Connection.new(input_node: input_node2, output_node: output_node, weight: 0.5)
    ]
  end

  it "has nodes" do
    expect(network.nodes).to eq(nodes)
  end

  it "has connections" do
    expect(network.connections).to eq(connections)
  end

  describe "#evaluate" do
    it "evaluates the network for a given set of inputs" do
      inputs = [0.5, 0.5]
      output = network.evaluate(inputs)
      expected_output = Morf::CPPN::ActivationFunctions.sigmoid(0.5 * 0.5 + 0.5 * 0.5)
      expect(output.first).to be_within(0.01).of(expected_output)
    end
  end
end
