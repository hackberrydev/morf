# frozen_string_literal: true

require "spec_helper"
require "morf/experiments/cppn/seed"

RSpec.describe Morf::Experiments::Cppn::Seed do
  subject(:seed) { described_class.new }

  describe "#state_for(row:, column:)" do
    it "returns an integer between 0 and 3" do
      state = seed.state_for(row: 0, column: 0)
      expect(state).to be_between(0, 3).inclusive
    end
  end

  describe "#default_state" do
    it "returns 0 for out-of-bounds cells" do
      expect(seed.default_state).to eq(0)
    end
  end
end
