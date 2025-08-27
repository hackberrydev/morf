# frozen_string_literal: true

require "spec_helper"
require "morf/cppn/network_factory"
require "morf/cppn/network"
require "morf/cppn/node"

RSpec.describe Morf::CPPN::NetworkFactory do
  describe ".build" do
    subject(:network) do
      described_class.build(
        num_inputs: num_inputs,
        num_outputs: num_outputs,
        input_activation_function: input_activation,
        output_activation_function: output_activation
      )
    end

    let(:num_inputs) { 2 }
    let(:num_outputs) { 3 }
    let(:input_activation) { :sigmoid }
    let(:output_activation) { :identity }

    it "returns a Morf::CPPN::Network" do
      expect(network).to be_a(Morf::CPPN::Network)
    end

    it "creates the correct number of input nodes" do
      expect(network.input_nodes.size).to eq(num_inputs)
    end

    it "creates the correct number of output nodes" do
      expect(network.output_nodes.size).to eq(num_outputs)
    end

    it "assigns the correct activation function to input nodes" do
      expect(network.input_nodes.first.activation_function).to eq(input_activation)
    end

    it "assigns the correct activation function to output nodes" do
      expect(network.output_nodes.first.activation_function).to eq(output_activation)
    end

    it "creates a fully connected network" do
      total_connections = num_inputs * num_outputs
      expect(network.connections.size).to eq(total_connections)
    end
  end
end
