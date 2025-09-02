# frozen_string_literal: true

require "spec_helper"
require "morf/neat/genome"

RSpec.describe Morf::NEAT::Genome do
  subject(:genome) { described_class.new(node_genes: node_genes, connection_genes: connection_genes) }

  let(:node_genes) { [] }
  let(:connection_genes) { [] }

  it "has node genes" do
    expect(genome.node_genes).to eq(node_genes)
  end

  it "has connection genes" do
    expect(genome.connection_genes).to eq(connection_genes)
  end
end
