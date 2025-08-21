# frozen_string_literal: true

require "spec_helper"
require "morf/cppn/brain"
require "morf/cppn/network"

RSpec.describe Morf::CPPN::Brain do
  subject(:brain) { described_class.new(network: network) }

  let(:network) { instance_double(Morf::CPPN::Network) }

  describe "#next_state" do
    let(:state) { 1 }
    let(:inputs) { [0.5, 0.25] }

    before do
      allow(network).to receive(:evaluate).and_return([0.75])
    end

    it "calls the network's evaluate method with the correct inputs" do
      brain.next_state(state, inputs)
      expect(network).to have_received(:evaluate).with([state] + inputs)
    end

    it "returns the first element of the network's output" do
      output = brain.next_state(state, inputs)
      expect(output).to eq(0.75)
    end
  end
end
