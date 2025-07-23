require "spec_helper"
require "morf/experiments/game_of_life/brain"

RSpec.describe Morf::Experiments::GameOfLife::Brain do
  let(:brain) { described_class.new }

  describe "a live cell" do
    it "dies with fewer than two live neighbours" do
      aggregate_failures do
        expect(brain.next_state(1, 0)).to eq(0)
        expect(brain.next_state(1, 1)).to eq(0)
      end
    end

    it "lives with two or three live neighbours" do
      aggregate_failures do
        expect(brain.next_state(1, 2)).to eq(1)
        expect(brain.next_state(1, 3)).to eq(1)
      end
    end

    it "dies with more than three live neighbours" do
      expect(brain.next_state(1, 4)).to eq(0)
    end
  end

  describe "a dead cell" do
    it "becomes a live cell with exactly three live neighbours" do
      expect(brain.next_state(0, 3)).to eq(1)
    end

    it "stays dead with other than three live neighbours" do
      expect(brain.next_state(0, 2)).to eq(0)
    end
  end
end
