# frozen_string_literal: true

require "spec_helper"
require "morf/neat/node_gene"

RSpec.describe Morf::NEAT::NodeGene do
  subject(:node_gene) { described_class.new(id: id, type: type, activation_function: activation_function) }

  let(:id) { 1 }
  let(:type) { :hidden }
  let(:activation_function) { :sigmoid }

  it "has an id" do
    expect(node_gene.id).to eq(id)
  end

  it "has a type" do
    expect(node_gene.type).to eq(type)
  end

  it "has an activation function" do
    expect(node_gene.activation_function).to eq(activation_function)
  end
end
