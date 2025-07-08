require "morf/grid"
require "morf/clock"
require "morf/grid_view"
require "morf/experiments/dummy/brain"
require "morf/experiments/dummy/sensor"
require "morf/experiments/dummy/cell_view"

module Morf
  module Experiments
    module Dummy
      class Experiment
        def run
          clock = Morf::Clock.new

          grid = Morf::Grid.new(
            brain_class: Morf::Experiments::Dummy::Brain,
            sensor_class: Morf::Experiments::Dummy::Sensor,
            clock: clock,
            rows: 100,
            columns: 100
          )

          grid_view = Morf::GridView.new(
            grid: grid,
            cell_view_class: Morf::Experiments::Dummy::CellView
          )

          # Blocks, so it doesn't work.
          grid_view.show

          10.times do
            clock.cycle

            grid_view.render_cells

            sleep 1

            puts "Cycle..."
          end

          grid_view.close

          puts "Experiment done."
        end
      end
    end
  end
end
