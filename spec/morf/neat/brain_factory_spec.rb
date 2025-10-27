# frozen_string_literal: true

require "spec_helper"
require "morf/neat/brain_factory"
require "morf/neat/genome"
require "morf/cppn/brain"

RSpec.describe Morf::NEAT::BrainFactory do
  subject(:factory) { described_class.new(genome) }

  let(:genome) { instance_double(Morf::NEAT::Genome) }
  let(:network) { instance_double(Morf::CPPN::Network) }
  let(:brain) { instance_double(Morf::CPPN::Brain) }
  let(:network_builder) { instance_double(Morf::NEAT::NetworkBuilder, build: network) }

  before do
    allow(Morf::NEAT::NetworkBuilder).to receive(:new).with(genome).and_return(network_builder)
    allow(Morf::CPPN::Brain).to receive(:new).with(network: network).and_return(brain)
  end

  describe "#create_brain" do
    it "builds a new network from the genome and wraps it in a brain" do
      expect(factory.create_brain).to eq(brain)
    end
  end
end
