module Morf
  class Grid
    def initialize(cell_class:, rows:, columns:)
      @rows = rows
      @columns = columns

      @grid = Array.new(@rows) do
        Array.new(@columns) { cell_class.new }
      end
    end

    def cell(row:, column:)
      @grid[row][column]
    end
  end
end
