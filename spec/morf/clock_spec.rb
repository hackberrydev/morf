require "spec_helper"

RSpec.describe Morf::Clock do
  describe "#cycle" do
    let(:clock) { Morf::Clock.new }
    let(:subscriber) { double("subscriber") }

    it "returns the number of cycles" do
      8.times { clock.cycle }
      expect(clock.cycle).to eq(9)
    end

    it "calls `tick` on all subscribers" do
      allow(subscriber).to receive(:tick)

      clock.on_tick { subscriber.tick }
      clock.cycle

      expect(subscriber).to have_received(:tick)
    end

    it "calls `tack` on all subscribers" do
      allow(subscriber).to receive(:tack)

      clock.on_tack { subscriber.tack }
      clock.cycle

      expect(subscriber).to have_received(:tack)
    end

    it "calls `tock` on all subscribers" do
      allow(subscriber).to receive(:tock)

      clock.on_tock { subscriber.tock }
      clock.cycle

      expect(subscriber).to have_received(:tock)
    end
  end
end
