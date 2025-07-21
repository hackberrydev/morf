require "ruby2d"

module Morf
  class GridView
    def initialize(clock:, grid:, cell_view_class:, cell_size: 5, time_limit: 10)
      super()

      @clock = clock
      @grid = grid
      @cell_view_class = cell_view_class
      @cell_size = cell_size
      @time_limit = time_limit

      @start_at = Time.now
    end

    def show
      Window.set(
        title: "Morf Experiment",
        width: @grid.columns * @cell_size,
        height: @grid.rows * @cell_size
      )

      Window.update do
        @clock.cycle

        if Time.now - @start_at > @time_limit
          Window.close

          puts "Completed #{@clock.cycle_count} cycles in #{@time_limit}s."
        end
      end

      Window.render do
        cell_views.each(&:render)
      end

      Window.show
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
