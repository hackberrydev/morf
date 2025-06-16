require "josif/clock"

describe Josif::Clock do
  describe "#cycle" do
    before do
      @clock = Josif::Clock.new
      @subscriber = Minitest::Mock.new
    end

    it "calls `tick` on all subscribers" do
      @subscriber.expect :tick, nil

      @clock.on_tick { @subscriber.tick }
      @clock.cycle

      @subscriber.verify
    end

    it "calls `tack` on all subscribers" do
      @subscriber.expect :tack, nil

      @clock.on_tack { @subscriber.tack }
      @clock.cycle

      @subscriber.verify
    end
  end
end
