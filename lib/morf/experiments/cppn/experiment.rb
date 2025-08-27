require "morf/grid"
require "morf/clock"
require "morf/grid_view"
require "morf/experiments/cppn/brain"
require "morf/cppn/sensor"
require "morf/experiments/cppn/cell_view"
require "morf/experiments/cppn/seed"

module Morf
  module Experiments
    module Cppn
      class Experiment
        def run
          clock = Morf::Clock.new

          grid = Morf::Grid.new(
            clock: clock,
            brain_class: Morf::Experiments::Cppn::Brain,
            sensor_class: Morf::CPPN::Sensor,
            seed: Morf::Experiments::Cppn::Seed.new,
            rows: 6,
            columns: 6
          )

          grid_view = Morf::GridView.new(
            clock: clock,
            grid: grid,
            cell_view_class: Morf::Experiments::Cppn::CellView,
            cell_size: 20,
            time_limit: 30
          )

          puts "CPPN Experiment start."

          grid_view.show

          puts "CPPN Experiment done."
        end
      end
    end
  end
end
