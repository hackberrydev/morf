require "morf/grid"
require "morf/experiments/dummy/brain"
require "morf/experiments/dummy/sensor"

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

          10.times do
            clock.cycle

            sleep 1
          end
        end
      end
    end
  end
end
