# frozen_string_literal: true

require "spec_helper"
require "morf/cppn/node"
require "morf/cppn/connection"
require "morf/cppn/network"

RSpec.describe Morf::CPPN::Network do
  subject(:network) { described_class.new(nodes: nodes, connections: connections) }

  let(:input_node) { Morf::CPPN::Node.new(id: 1, layer: :input) }
  let(:output_node) { Morf::CPPN::Node.new(id: 2, layer: :output) }
  let(:nodes) { [input_node, output_node] }
  let(:connections) { [Morf::CPPN::Connection.new(input_node: input_node, output_node: output_node, weight: 0.5)] }

  it "has nodes" do
    expect(network.nodes).to eq(nodes)
  end

  it "has connections" do
    expect(network.connections).to eq(connections)
  end
end
