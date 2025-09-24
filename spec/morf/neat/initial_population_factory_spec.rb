# frozen_string_literal: true

require "spec_helper"
require "morf/neat/initial_population_factory"
require "morf/experiments/neat/constants"

RSpec.describe Morf::NEAT::InitialPopulationFactory do
  subject(:factory) { described_class.new }

  let(:size) { 10 }
  let(:cppn_inputs) { Morf::Experiments::NEAT::Constants::CPPN_INPUTS }
  let(:cppn_outputs) { Morf::Experiments::NEAT::Constants::CPPN_OUTPUTS }
  let(:next_innovation_number) { 0 }

  describe "#create" do
    let(:result) do
      factory.create(
        size: size,
        cppn_inputs: cppn_inputs,
        cppn_outputs: cppn_outputs,
        next_innovation_number: next_innovation_number
      )
    end
    let(:genomes) { result[:genomes] }
    let(:new_next_innovation_number) { result[:next_innovation_number] }

    it "creates the correct number of genomes" do
      expect(genomes.size).to eq(size)
    end

    it "returns the next innovation number" do
      expect(new_next_innovation_number).to be > next_innovation_number
    end

    context "with each genome" do
      let(:genome) { genomes.first }
      let(:nodes) { genome.node_genes }
      let(:connections) { genome.connection_genes }

      it "has the correct number of nodes" do
        expect(nodes.size).to eq(cppn_inputs + cppn_outputs)
      end

      it "has the correct number of input nodes" do
        expect(nodes.count { |n| n.type == :input }).to eq(cppn_inputs)
      end

      it "has the correct number of output nodes" do
        expect(nodes.count { |n| n.type == :output }).to eq(cppn_outputs)
      end

      it "has at least one connection" do
        expect(connections).not_to be_empty
      end

      it "has connections with valid node IDs" do
        node_ids = nodes.map(&:id)

        aggregate_failures do
          connections.each do |c|
            expect(node_ids).to include(c.in_node_id)
            expect(node_ids).to include(c.out_node_id)
          end
        end
      end
    end
  end
end
