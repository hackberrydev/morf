require "morf/grid"
require "morf/clock"
require "morf/grid_view"
require "morf/default_brain_factory"
require "morf/experiments/dummy/brain"
require "morf/experiments/dummy/sensor"
require "morf/experiments/dummy/cell_view"
require "morf/experiments/dummy/seed"

module Morf
  module Experiments
    module Dummy
      class Experiment
        def run
          clock = Morf::Clock.new

          grid = Morf::Grid.new(
            clock: clock,
            brain_factory: Morf::DefaultBrainFactory.new(Morf::Experiments::Dummy::Brain),
            sensor_class: Morf::Experiments::Dummy::Sensor,
            seed: Morf::Experiments::Dummy::Seed.new,
            rows: 100,
            columns: 100
          )

          grid_view = Morf::GridView.new(
            clock: clock,
            grid: grid,
            cell_view_class: Morf::Experiments::Dummy::CellView
          )

          puts "Experiment start."

          grid_view.show

          puts "Experiment done."
        end
      end
    end
  end
end
