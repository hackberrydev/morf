require "ruby2d"

module Morf
  class GridView < Ruby2D::Window
    def initialize(grid:, cell_view_class:, cell_size: 5)
      super()

      @grid = grid
      @cell_view_class = cell_view_class
      @cell_size = cell_size

      set(
        title: "Morf Experiment",
        width: @grid.columns * @cell_size,
        height: @grid.rows * @cell_size
      )
    end

    def update
    end

    def render
      render_cells
    end

    def render_cells
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
