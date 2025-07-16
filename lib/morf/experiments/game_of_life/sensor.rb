# frozen_string_literal: true

module Morf
  module Experiments
    module GameOfLife
      class Sensor
        def initialize(grid:, row:, column:)
          @grid = grid
          @row = row
          @column = column
        end

        def sense
          count = 0
          rows = @grid.rows
          columns = @grid.columns

          (-1..1).each do |y_offset|
            (-1..1).each do |x_offset|
              next if y_offset.zero? && x_offset.zero?

              y = @row + y_offset
              x = @column + x_offset

              next if y.negative? || y >= rows
              next if x.negative? || x >= columns

              count += 1 if @grid.cell(row: y, column: x).state == 1
            end
          end
          count
        end
      end
    end
  end
end
