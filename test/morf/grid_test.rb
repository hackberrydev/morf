require "morf/grid"
require "morf/experiments/dummy/brain"
require "morf/experiments/dummy/sensor"

describe Morf::Grid do
  describe "initialization" do
    it "initializes a grid of cells with the correct number of rows and columns" do
      grid = Morf::Grid.new(
        brain_class: Morf::Experiments::Dummy::Brain,
        sensor_class: Morf::Experiments::Dummy::Sensor,
        clock: Morf::Clock.new,
        rows: 4,
        columns: 8
      )

      _(grid.cell(row: 2, column: 7).instance_of?(Morf::Cell)).must_equal true
    end
  end
end
