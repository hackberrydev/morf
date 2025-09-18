require "spec_helper"
require "morf/default_brain_factory"
require "morf/experiments/dummy/brain"
require "morf/experiments/dummy/sensor"

RSpec.describe Morf::Grid do
  subject(:grid) do
    described_class.new(
      brain_factory: brain_factory,
      sensor_class: Morf::Experiments::Dummy::Sensor,
      clock: Morf::Clock.new,
      rows: 4,
      columns: 8,
      seed: seed
    )
  end

  let(:brain_factory) { Morf::DefaultBrainFactory.new(Morf::Experiments::Dummy::Brain) }
  let(:seed) { double("Seed", state_for: 0, default_state: -1) }

  it "initializes a grid of cells with the correct number of rows and columns" do
    expect(grid.cell(row: 2, column: 7)).to be_a(Morf::Cell)
  end

  it "returns a null cell for coordinates that are out of bounds" do
    aggregate_failures do
      expect(grid.cell(row: -1, column: 0)).to be_a(Morf::NullCell)
      expect(grid.cell(row: 0, column: -1)).to be_a(Morf::NullCell)
      expect(grid.cell(row: 4, column: 0)).to be_a(Morf::NullCell)
      expect(grid.cell(row: 0, column: 8)).to be_a(Morf::NullCell)
    end
  end

  it "initializes the null cell with the default state from the seed" do
    expect(grid.cell(row: -1, column: 0).state).to eq(-1)
  end

  it "returns the total number of cells" do
    expect(grid.total_cells).to eq(32)
  end
end
