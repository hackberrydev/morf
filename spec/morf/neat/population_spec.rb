# frozen_string_literal: true

require "spec_helper"
require "morf/neat/population"
require "morf/neat/genome"
require "morf/neat/node_gene"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::Population do
  subject(:population) { described_class.new(genomes: genomes) }

  let(:genomes) do
    [
      Morf::NEAT::Genome.new(node_genes: [], connection_genes: []),
      Morf::NEAT::Genome.new(node_genes: [], connection_genes: [])
    ]
  end

  it "has genomes" do
    expect(population.genomes).to eq(genomes)
  end
end
