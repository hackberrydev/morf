# frozen_string_literal: true

require "morf/cell"
require "morf/null_cell"

module Morf
  class Grid
    attr_reader :rows, :columns

    def initialize(brain_class:, sensor_class:, clock:, rows:, columns:, seed:)
      @brain_class = brain_class
      @sensor_class = sensor_class
      @clock = clock
      @rows = rows
      @columns = columns
      @seed = seed

      @null_cell = Morf::NullCell.new(state: @seed.default_state)
      @grid = initialize_grid
    end

    def cell(row:, column:)
      return @null_cell if out_of_bounds?(row: row, column: column)

      @grid[row][column]
    end

    private

    def out_of_bounds?(row:, column:)
      row.negative? || row >= @rows || column.negative? || column >= @columns
    end

    def initialize_grid
      grid = []

      (0...@rows).each do |row|
        grid[row] = []

        (0...@columns).each do |column|
          grid[row][column] = Morf::Cell.new(
            brain: @brain_class.new,
            sensor: @sensor_class.new(grid: self, row: row, column: column),
            clock: @clock,
            state: @seed.state_for(row: row, column: column)
          )
        end
      end

      grid
    end
  end
end
