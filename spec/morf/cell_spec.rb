require "spec_helper"

RSpec.describe Morf::Cell do
  subject!(:cell) do
    described_class.new(
      brain: brain,
      sensor: sensor,
      clock: clock,
      state: state
    )
  end

  let(:clock) { Morf::Clock.new }
  let(:state) { 0 }
  let(:sensor) { double("Sensor", sense: 0) }
  let(:brain) { double("Brain", next_state: 1) }

  describe "initialization" do
    it "initializes with a state" do
      expect(cell.state).to eq(state)
    end

    it "invokes sensor each cycle" do
      clock.cycle

      expect(sensor).to have_received(:sense)
    end

    it "invokes brain each cycle" do
      clock.cycle

      expect(brain).to have_received(:next_state).with(state, 0)
    end

    it "moves cell to the new state" do
      clock.cycle

      expect(cell.state).to eq(1)
    end
  end
end
