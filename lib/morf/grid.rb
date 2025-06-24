module Morf
  class Grid
    def initialize(brain_class:, sensor_class:, clock:, rows:, columns:)
      @rows = rows
      @columns = columns

      @grid = Array.new(@rows) do
        Array.new(@columns) do
          Morf::Cell.new(
            brain: brain_class.new,
            sensor: sensor_class.new,
            clock: clock
          )
        end
      end
    end

    def cell(row:, column:)
      @grid[row][column]
    end
  end
end
