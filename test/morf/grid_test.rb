require "test_helper"
require "morf/experiments/dummy/brain"
require "morf/experiments/dummy/sensor"

describe Morf::Grid do
  let(:seed) do
    s = Object.new
    def s.state_for(row:, column:)
      0
    end

    def s.default_state
      -1
    end
    s
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
    _(grid.cell(row: 2, column: 7).instance_of?(Morf::Cell)).must_equal true
  end

  it "returns a null cell for coordinates that are out of bounds" do
    _(grid.cell(row: -1, column: 0).instance_of?(Morf::NullCell)).must_equal true
    _(grid.cell(row: 0, column: -1).instance_of?(Morf::NullCell)).must_equal true
    _(grid.cell(row: 4, column: 0).instance_of?(Morf::NullCell)).must_equal true
    _(grid.cell(row: 0, column: 8).instance_of?(Morf::NullCell)).must_equal true
  end

  it "initializes the null cell with the default state from the seed" do
    _(grid.cell(row: -1, column: 0).state).must_equal(-1)
  end
end
