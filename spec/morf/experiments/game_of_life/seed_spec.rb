# frozen_string_literal: true

require "spec_helper"
require "morf/experiments/game_of_life/seed"

RSpec.describe Morf::Experiments::GameOfLife::Seed do
  let(:seed) { described_class.new }

  describe "#state_for(row:, column:)" do
    it "returns 1 for alive or 0 for dead" do
      state = seed.state_for(row: 0, column: 0)
      expect(state).to eq(0).or(eq(1))
    end
  end

  describe "#default_state" do
    it "returns 0 for out-of-bounds cells" do
      expect(seed.default_state).to eq(0)
    end
  end
end
