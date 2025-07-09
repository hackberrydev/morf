require "ruby2d"

module Morf
  class GridView < Ruby2D::Window
    def initialize(clock:, grid:, cell_view_class:, cell_size: 5, time_limit: 10)
      super()

      @clock = clock
      @grid = grid
      @cell_view_class = cell_view_class
      @cell_size = cell_size
      @time_limit = time_limit

      @start_at = Time.now
      @cycle = 0

      set(
        title: "Morf Experiment",
        width: @grid.columns * @cell_size,
        height: @grid.rows * @cell_size
      )
    end

    def update
      @clock.cycle if @cycle % 60 == 0

      @cycle += 1

      close if Time.now - @start_at > @time_limit
    end

    def render
      cell_views.each(&:render)
    end

    private

    def cell_views
      @cell_views ||= initialize_cell_views
    end

    def initialize_cell_views
      cell_views = []

      (0...@grid.rows).each do |y|
        (0...@grid.columns).each do |x|
          cell_views << @cell_view_class.new(
            cell: @grid.cell(row: y, column: x),
            cell_size: @cell_size,
            x: x,
            y: y
          )
        end
      end

      cell_views
    end
  end
end
