require "morf/grid"

describe Morf::Grid do
  describe "initialization" do
    it "initializes a grid of cells with the correct number of rows and columns" do
      brain_class = Minitest::Mock.new
      brain_class.expect(:new, nil)

      sensor_class = Minitest::Mock.new
      sensor_class.expect(:new, nil)

      grid = Morf::Grid.new(
        brain_class: brain_class,
        sensor_class: sensor_class,
        clock: Morf::Clock.new,
        rows: 4,
        columns: 8
      )

      _(grid.cell(row: 2, column: 7).instance_of?(Morf::Cell)).must_equal true
    end
  end
end
