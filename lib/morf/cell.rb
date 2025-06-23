module Morf
  class Cell
    def initialize(brain:, sensor:, clock:)
      @brain = brain
      @sensor = sensor

      @state = nil

      clock.on_tick { sense }
      clock.on_tack { next_state }
    end

    private

    def sense
      @sensor.sense
    end

    def next_state
      @state = @brain.next_state
    end
  end
end
