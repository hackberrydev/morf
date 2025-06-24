module Morf
  class Cell
    attr_reader :state

    def initialize(brain:, sensor:, clock:)
      @brain = brain
      @sensor = sensor

      @neighbourhood = nil
      @state = nil

      clock.on_tick { sense }
      clock.on_tack { next_state }
    end

    private

    def sense
      @neighbourhood = @sensor.sense
    end

    def next_state
      @state = @brain.next_state(@neighbourhood)
    end
  end
end
