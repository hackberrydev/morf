# frozen_string_literal: true

require "spec_helper"
require "morf/sensors/von_neumann_sensor"
require "morf/grid"
require "morf/cell"

RSpec.describe Morf::Sensors::VonNeumannSensor do
  subject(:sensor) { described_class.new(grid: grid, row: row, column: column) }

  let(:row) { 5 }
  let(:column) { 5 }

  describe "#sense" do
    context "when all neighbors have the same state" do
      let(:grid) do
        instance_double(Morf::Grid, cell: instance_double(Morf::Cell, state: 1))
      end

      it "returns exactly 4 neighbor states" do
        result = sensor.sense
        expect(result.length).to eq(4)
      end

      it "returns the states of the von Neumann neighborhood" do
        expect(sensor.sense).to eq([1, 1, 1, 1])
      end
    end

    context "when neighbors have different states" do
      let(:grid) { instance_double(Morf::Grid) }
      let(:top_cell) { instance_double(Morf::Cell, state: 1) }
      let(:right_cell) { instance_double(Morf::Cell, state: 2) }
      let(:bottom_cell) { instance_double(Morf::Cell, state: 3) }
      let(:left_cell) { instance_double(Morf::Cell, state: 4) }

      before do
        allow(grid).to receive(:cell).with(row: row - 1, column: column).and_return(top_cell)
        allow(grid).to receive(:cell).with(row: row, column: column + 1).and_return(right_cell)
        allow(grid).to receive(:cell).with(row: row + 1, column: column).and_return(bottom_cell)
        allow(grid).to receive(:cell).with(row: row, column: column - 1).and_return(left_cell)
      end

      it "returns neighbors in correct order: top, right, bottom, left" do
        expect(sensor.sense).to eq([1, 2, 3, 4])
      end
    end

    context "when at grid boundaries" do
      let(:grid) { instance_double(Morf::Grid) }
      let(:null_cell) { instance_double(Morf::Cell, state: 0) }
      let(:normal_cell) { instance_double(Morf::Cell, state: 1) }

      before do
        # Top boundary - top neighbor is out of bounds
        allow(grid).to receive(:cell).with(row: row - 1, column: column).and_return(null_cell)
        allow(grid).to receive(:cell).with(row: row, column: column + 1).and_return(normal_cell)
        allow(grid).to receive(:cell).with(row: row + 1, column: column).and_return(normal_cell)
        allow(grid).to receive(:cell).with(row: row, column: column - 1).and_return(normal_cell)
      end

      it "handles boundary conditions correctly using NullCell" do
        result = sensor.sense
        expect(result).to eq([0, 1, 1, 1])
      end
    end
  end
end
