# frozen_string_literal: true

require "spec_helper"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::ConnectionGene do
  subject(:connection_gene) do
    described_class.new(
      in_node_id: in_node_id,
      out_node_id: out_node_id,
      weight: weight,
      enabled: enabled,
      innovation_number: innovation_number
    )
  end

  let(:in_node_id) { 1 }
  let(:out_node_id) { 2 }
  let(:weight) { 0.5 }
  let(:enabled) { true }
  let(:innovation_number) { 1 }

  it "has an in_node_id" do
    expect(connection_gene.in_node_id).to eq(in_node_id)
  end

  it "has an out_node_id" do
    expect(connection_gene.out_node_id).to eq(out_node_id)
  end

  it "has a weight" do
    expect(connection_gene.weight).to eq(weight)
  end

  it "has an enabled status" do
    expect(connection_gene.enabled).to eq(enabled)
  end

  it "has an innovation_number" do
    expect(connection_gene.innovation_number).to eq(innovation_number)
  end
end
