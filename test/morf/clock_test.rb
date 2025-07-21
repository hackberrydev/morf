require "test_helper"

describe Morf::Clock do
  describe "#cycle" do
    before do
      @clock = Morf::Clock.new
      @subscriber = Minitest::Mock.new
    end

    it "returns the number of cycles" do
      8.times { @clock.cycle }

      _(@clock.cycle).must_equal 9
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

    it "calls `tock` on all subscribers" do
      @subscriber.expect :tock, nil

      @clock.on_tock { @subscriber.tock }
      @clock.cycle

      @subscriber.verify
    end
  end
end
