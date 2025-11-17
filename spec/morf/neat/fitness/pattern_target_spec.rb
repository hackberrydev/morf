# frozen_string_literal: true

require "morf/neat/fitness"
require "morf/grid"
require "morf/cell"

RSpec.describe Morf::NEAT::Fitness::PatternTarget do
  subject(:pattern_target) { described_class.new(target_pattern) }

  let(:target_pattern) do
    [
      [1, 1],
      [1, 1]
    ]
  end

  it "is initialized with a target_pattern" do
    expect(pattern_target.target_pattern).to eq(target_pattern)
  end

  describe "#evaluate" do
    let(:grid) do
      instance_double(Morf::Grid, rows: 2, columns: 2, total_cells: 4).tap do |grid_double|
        allow(grid_double).to receive(:cell)
          .with(row: 0, column: 0)
          .and_return(instance_double(Morf::Cell, state: 1))

        allow(grid_double).to receive(:cell)
          .with(row: 0, column: 1)
          .and_return(instance_double(Morf::Cell, state: 1))

        allow(grid_double).to receive(:cell)
          .with(row: 1, column: 0)
          .and_return(instance_double(Morf::Cell, state: 1))

        allow(grid_double).to receive(:cell)
          .with(row: 1, column: 1)
          .and_return(instance_double(Morf::Cell, state: 1))
      end
    end

    it "returns 1.0 when the grid perfectly matches the target pattern" do
      expect(pattern_target.evaluate(grid)).to eq 1.0
    end

    context "when there is a partial match" do
      let(:grid) do
        instance_double(Morf::Grid, rows: 2, columns: 2, total_cells: 4).tap do |grid_double|
          allow(grid_double).to receive(:cell)
            .with(row: 0, column: 0)
            .and_return(instance_double(Morf::Cell, state: 1))

          allow(grid_double).to receive(:cell)
            .with(row: 0, column: 1)
            .and_return(instance_double(Morf::Cell, state: 0))

          allow(grid_double).to receive(:cell)
            .with(row: 1, column: 0)
            .and_return(instance_double(Morf::Cell, state: 1))

          allow(grid_double).to receive(:cell)
            .with(row: 1, column: 1)
            .and_return(instance_double(Morf::Cell, state: 0))
        end
      end

      it "returns the correct fitness value" do
        expect(pattern_target.evaluate(grid)).to eq 0.5
      end
    end
  end
end
