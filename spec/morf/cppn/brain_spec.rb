# frozen_string_literal: true

require "spec_helper"
require "morf/cppn/brain"
require "morf/cppn/network"

RSpec.describe Morf::CPPN::Brain do
  subject(:brain) { described_class.new(network: network) }

  let(:network) { instance_double(Morf::CPPN::Network) }
  let(:output_nodes) { Array.new(num_outputs) }

  before do
    allow(network).to receive(:output_nodes).and_return(output_nodes)
  end

  describe "#next_state" do
    let(:state) { 1 }
    let(:inputs) { [0, 2, 3] }

    before do
      allow(network).to receive(:evaluate).and_return([0.1, 0.8, 0.3, 0.2])
    end

    context "with 4 outputs (states 0-3)" do
      let(:num_outputs) { 4 }

      it "normalizes inputs to avoid sigmoid saturation" do
        brain.next_state(state, inputs)

        # Formula: (value / num_outputs) * 2.0 - 1.0
        # 0 -> -1.0, 1 -> -0.5, 2 -> 0.0, 3 -> 0.5
        expected_normalized = [
          -0.5,  # state 1
          -1.0,  # 0
          0.0,   # 2
          0.5    # 3
        ]

        expect(network).to have_received(:evaluate).with(expected_normalized)
      end

      it "returns the index of the highest output value" do
        output = brain.next_state(state, inputs)
        expect(output).to eq(1)
      end
    end
  end
end
