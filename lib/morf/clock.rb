module Morf
  # A clock that runs in three phases per cycle: tick, tack, and tock.
  # Observers can subscribe to each phase via the  `on_tick`, `on_tack`, and `on_tock` methods.
  # Calling `cycle` will invoke all subscriber blocks in phase order: tick, tack, tock.
  #
  # @example
  #   clock = Morf::Clock.new
  #   clock.on_tick { puts "tick" }
  #   clock.on_tack { puts "tack" }
  #   clock.on_tock { puts "tock" }
  #   clock.cycle
  #   # => tick
  #   # => tack
  #   # => tock
  class Clock
    def initialize
      @tick_subscribers = []
      @tack_subscribers = []
      @tock_subscribers = []
    end

    def on_tick(&block)
      @tick_subscribers << block
    end

    def on_tack(&block)
      @tack_subscribers << block
    end

    def on_tock(&block)
      @tock_subscribers << block
    end

    def cycle
      @tick_subscribers.each(&:call)
      @tack_subscribers.each(&:call)
      @tock_subscribers.each(&:call)
    end
  end
end
