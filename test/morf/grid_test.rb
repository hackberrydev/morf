require "morf/grid"

class CellStub
end

describe Morf::Grid do
  describe "initialization" do
    it "initializes a grid of cells with the correct number of rows and columns" do
      grid = Morf::Grid.new(cell_class: CellStub, rows: 4, columns: 8)

      _(grid.cell(row: 2, column: 7).instance_of?(CellStub)).must_equal true
    end
  end
end
