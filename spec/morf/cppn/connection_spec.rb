# frozen_string_literal: true

require "spec_helper"
require "morf/cppn/node"
require "morf/cppn/connection"

RSpec.describe Morf::CPPN::Connection do
  subject(:connection) { described_class.new(input_node: input_node, output_node: output_node, weight: 0.5) }

  let(:input_node) { Morf::CPPN::Node.new(id: 1, layer: :input, activation_function: :sigmoid) }
  let(:output_node) { Morf::CPPN::Node.new(id: 2, layer: :output, activation_function: :sigmoid) }

  it "has an input node" do
    expect(connection.input_node).to eq(input_node)
  end

  it "has an output node" do
    expect(connection.output_node).to eq(output_node)
  end

  it "has a weight" do
    expect(connection.weight).to eq(0.5)
  end
end
