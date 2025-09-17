# frozen_string_literal: true

require "spec_helper"
require "morf/neat/network_builder"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::NetworkBuilder do
  subject(:builder) { described_class.new(genome) }

  let(:genome) do
    Morf::NEAT::Genome.new(node_genes: node_genes, connection_genes: connection_genes)
  end

  let(:node_genes) do
    [
      Morf::NEAT::NodeGene.new(id: 1, type: :input, activation_function: :identity),
      Morf::NEAT::NodeGene.new(id: 2, type: :output, activation_function: :sigmoid)
    ]
  end

  let(:connection_genes) do
    [
      Morf::NEAT::ConnectionGene.new(in_node_id: 1, out_node_id: 2, weight: 0.5, enabled: true, innovation_number: 1),
      Morf::NEAT::ConnectionGene.new(in_node_id: 2, out_node_id: 1, weight: 0.2, enabled: false, innovation_number: 2)
    ]
  end

  describe "#build" do
    let(:network) { builder.build }

    it "creates a network with the correct number of nodes" do
      expect(network.instance_variable_get(:@nodes).size).to eq(2)
    end

    it "creates a network with the correct number of connections" do
      expect(network.instance_variable_get(:@connections).size).to eq(1)
    end

    it "only creates connections for enabled genes" do
      connection = network.instance_variable_get(:@connections).first
      expect(connection.weight).to eq(0.5)
    end
  end
end
