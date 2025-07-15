require "test_helper"
require "morf/experiments/game_of_life/brain"

describe Morf::Experiments::GameOfLife::Brain do
  let(:brain) { Morf::Experiments::GameOfLife::Brain.new }

  describe "a live cell" do
    it "dies with fewer than two live neighbours" do
      _(brain.next_state(1, 0)).must_equal 0
      _(brain.next_state(1, 1)).must_equal 0
    end

    it "lives with two or three live neighbours" do
      _(brain.next_state(1, 2)).must_equal 1
      _(brain.next_state(1, 3)).must_equal 1
    end

    it "dies with more than three live neighbours" do
      _(brain.next_state(1, 4)).must_equal 0
    end
  end

  describe "a dead cell" do
    it "becomes a live cell with exactly three live neighbours" do
      _(brain.next_state(0, 3)).must_equal 1
    end

    it "stays dead with other than three live neighbours" do
      _(brain.next_state(0, 2)).must_equal 0
    end
  end
end
