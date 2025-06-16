module Josif
  class Clock
    def initialize
      @tick_subscribers = []
      @tack_subscribers = []
    end

    def on_tick(&block)
      @tick_subscribers << block
    end

    def on_tack(&block)
      @tack_subscribers << block
    end

    def cycle
      @tick_subscribers.each(&:call)
      @tack_subscribers.each(&:call)
    end
  end
end
