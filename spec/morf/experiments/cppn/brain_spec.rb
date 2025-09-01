# frozen_string_literal: true

require "spec_helper"
require "morf/experiments/cppn/brain"
require "morf/cppn/brain"

RSpec.describe Morf::Experiments::CPPN::Brain do
  subject(:brain) { described_class.new }

  describe "#next_state" do
    let(:state) { 1 }
    let(:inputs) { Array.new(8) { 0 } }
    let(:cppn_brain) { instance_double(Morf::CPPN::Brain) }

    before do
      allow(Morf::CPPN::Brain).to receive(:new).and_return(cppn_brain)
      allow(cppn_brain).to receive(:next_state).and_return(2)
    end

    it "normalizes the state and inputs before passing them to the CPPN brain" do
      brain.next_state(state, inputs)
      normalized_state = (0.5 * state) - 1.0
      normalized_inputs = inputs.map { |i| (0.5 * i) - 1.0 }
      expect(cppn_brain).to have_received(:next_state).with(normalized_state, normalized_inputs)
    end

    it "returns the result from the CPPN brain" do
      expect(brain.next_state(state, inputs)).to eq(2)
    end
  end
end
