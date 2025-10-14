# frozen_string_literal: true

module Morf
  module Sensors
    class VonNeumannSensor
      def initialize(grid:, row:, column:)
        @grid = grid
        @row = row
        @column = column
      end

      def sense
        [
          @grid.cell(row: @row - 1, column: @column).state, # top
          @grid.cell(row: @row, column: @column + 1).state, # right
          @grid.cell(row: @row + 1, column: @column).state, # bottom
          @grid.cell(row: @row, column: @column - 1).state  # left
        ]
      end
    end
  end
end
