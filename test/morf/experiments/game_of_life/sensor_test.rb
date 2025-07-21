# frozen_string_literal: true

require "test_helper"
require "morf/cell"
require "morf/null_cell"
require "morf/clock"
require "morf/experiments/game_of_life/sensor"

describe Morf::Experiments::GameOfLife::Sensor do
  let(:clock) { Morf::Clock.new }
  let(:brain) { Minitest::Mock.new }

  let(:live_cell) { Morf::Cell.new(state: 1, brain: brain, sensor: nil, clock: clock) }
  let(:dead_cell) { Morf::Cell.new(state: 0, brain: brain, sensor: nil, clock: clock) }

  describe "#sense" do
    it "returns 0 when there are no neighbors" do
      grid = Minitest::Mock.new
      (0..2).each do |y|
        (0..2).each do |x|
          next if y == 1 && x == 1

          grid.expect :cell, dead_cell, row: y, column: x
        end
      end

      sensor = Morf::Experiments::GameOfLife::Sensor.new(grid: grid, row: 1, column: 1)

      _(sensor.sense).must_equal 0
    end

    it "counts the number of live neighbors" do
      grid = Minitest::Mock.new
      (0..2).each do |y|
        (0..2).each do |x|
          next if y == 1 && x == 1

          grid.expect :cell, live_cell, row: y, column: x
        end
      end

      sensor = Morf::Experiments::GameOfLife::Sensor.new(grid: grid, row: 1, column: 1)

      _(sensor.sense).must_equal 8
    end

    it "does not count itself" do
      grid = Minitest::Mock.new
      (0..2).each do |y|
        (0..2).each do |x|
          next if y == 1 && x == 1

          grid.expect :cell, dead_cell, row: y, column: x
        end
      end

      sensor = Morf::Experiments::GameOfLife::Sensor.new(grid: grid, row: 1, column: 1)

      _(sensor.sense).must_equal 0
    end

    it "handles edge cases correctly" do
      grid = Object.new

      def grid.cell(row:, column:)
        if [[0, 1], [1, 0], [1, 1]].include?([row, column])
          Morf::NullCell.new(state: 1)
        else
          Morf::NullCell.new(state: 0)
        end
      end

      sensor = Morf::Experiments::GameOfLife::Sensor.new(grid: grid, row: 0, column: 0)

      _(sensor.sense).must_equal 3
    end
  end
end
