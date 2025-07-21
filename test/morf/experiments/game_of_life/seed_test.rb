# frozen_string_literal: true

require "test_helper"
require "morf/experiments/game_of_life/seed"

describe Morf::Experiments::GameOfLife::Seed do
  let(:seed) { Morf::Experiments::GameOfLife::Seed.new }

  describe "#state_for(row:, column:)" do
    it "returns 1 for alive or 0 for dead" do
      state = seed.state_for(row: 0, column: 0)
      _([0, 1]).must_include state
    end
  end

  describe "#default_state" do
    it "returns 0 for out-of-bounds cells" do
      _(seed.default_state).must_equal 0
    end
  end
end
