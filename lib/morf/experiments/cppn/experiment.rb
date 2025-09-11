require "morf/grid"
require "morf/clock"
require "morf/grid_view"
require "morf/experiments/cppn/brain"
require "morf/cppn/sensor"
require "morf/experiments/cppn/cell_view"
require "morf/experiments/cppn/seed"

module Morf
  module Experiments
    module CPPN
      class Experiment
        def run
          clock = Morf::Clock.new

          grid = Morf::Grid.new(
            clock: clock,
            brain_class: Morf::Experiments::CPPN::Brain,
            sensor_class: Morf::CPPN::Sensor,
            seed: Morf::Experiments::CPPN::Seed.new,
            rows: 6,
            columns: 6
          )

          color_map = {
            0 => "white",
            1 => "red",
            2 => "green",
            3 => "blue"
          }

          grid_view = Morf::GridView.new(
            clock: clock,
            grid: grid,
            cell_view_class: Morf::Experiments::CPPN::CellView,
            cell_size: 20,
            time_limit: 30,
            color_map: color_map
          )

          puts "CPPN Experiment start."

          grid_view.show

          puts "CPPN Experiment done."
        end
      end
    end
  end
end
