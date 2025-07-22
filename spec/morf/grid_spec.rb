require "spec_helper"
require "morf/experiments/dummy/brain"
require "morf/experiments/dummy/sensor"

RSpec.describe Morf::Grid do
  let(:seed) do
    instance_double("Seed", state_for: 0, default_state: -1)
  end

  let(:grid) do
    Morf::Grid.new(
      brain_class: Morf::Experiments::Dummy::Brain,
      sensor_class: Morf::Experiments::Dummy::Sensor,
      clock: Morf::Clock.new,
      rows: 4,
      columns: 8,
      seed: seed
    )
  end

  it "initializes a grid of cells with the correct number of rows and columns" do
    expect(grid.cell(row: 2, column: 7)).to be_a(Morf::Cell)
  end

  it "returns a null cell for coordinates that are out of bounds" do
    expect(grid.cell(row: -1, column: 0)).to be_a(Morf::NullCell)
    expect(grid.cell(row: 0, column: -1)).to be_a(Morf::NullCell)
    expect(grid.cell(row: 4, column: 0)).to be_a(Morf::NullCell)
    expect(grid.cell(row: 0, column: 8)).to be_a(Morf::NullCell)
  end

  it "initializes the null cell with the default state from the seed" do
    expect(grid.cell(row: -1, column: 0).state).to eq(-1)
  end
end
