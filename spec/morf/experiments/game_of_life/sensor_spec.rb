# frozen_string_literal: true

require "spec_helper"
require "morf/cell"
require "morf/null_cell"
require "morf/clock"
require "morf/experiments/game_of_life/sensor"

RSpec.describe Morf::Experiments::GameOfLife::Sensor do
  let(:clock) { Morf::Clock.new }
  let(:brain) { instance_double("Brain") }

  let(:live_cell) { Morf::Cell.new(state: 1, brain: brain, sensor: nil, clock: clock) }
  let(:dead_cell) { Morf::Cell.new(state: 0, brain: brain, sensor: nil, clock: clock) }

  describe "#sense" do
    it "returns 0 when there are no neighbors" do
      grid = instance_double("Grid")
      allow(grid).to receive(:cell).and_return(dead_cell)

      sensor = Morf::Experiments::GameOfLife::Sensor.new(grid: grid, row: 1, column: 1)

      expect(sensor.sense).to eq(0)
    end

    it "counts the number of live neighbors" do
      grid = instance_double("Grid")
      allow(grid).to receive(:cell).and_return(live_cell)

      sensor = Morf::Experiments::GameOfLife::Sensor.new(grid: grid, row: 1, column: 1)

      expect(sensor.sense).to eq(8)
    end

    it "does not count itself" do
      grid = instance_double("Grid")
      allow(grid).to receive(:cell).and_return(dead_cell)

      sensor = Morf::Experiments::GameOfLife::Sensor.new(grid: grid, row: 1, column: 1)

      expect(sensor.sense).to eq(0)
    end
  end
end
