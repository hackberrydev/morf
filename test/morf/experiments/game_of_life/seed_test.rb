require "test_helper"
require "morf/experiments/game_of_life/seed"

describe Morf::Experiments::GameOfLife::Seed do
  let(:seed) { Morf::Experiments::GameOfLife::Seed.new }

  it "returns the initial state for a given cell" do
    # This is a placeholder test.
    # The actual implementation will depend on the desired initial pattern.
    _(seed.state_for(row: 0, column: 0)).must_equal 0
  end
end
