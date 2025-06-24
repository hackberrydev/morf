require "morf/cell"

class BrainStub
  def next_state(_neighbourhood) = 1
end

class SensorStub
  def sense = [0, 1, 2]
end

describe Morf::Cell do
  before do
    @clock = Morf::Clock.new
  end

  describe "initialization" do
    it "invokes sensor each cycle" do
      sensor = Minitest::Mock.new
      sensor.expect(:sense, nil)

      Morf::Cell.new(brain: BrainStub.new, sensor: sensor, clock: @clock)

      @clock.cycle

      sensor.verify
    end

    it "invokes brain each cycle" do
      brain = Minitest::Mock.new
      brain.expect(:next_state, nil, [[0, 1, 2]])

      Morf::Cell.new(brain: brain, sensor: SensorStub.new, clock: @clock)

      @clock.cycle

      brain.verify
    end

    it "moves cell to the new state" do
      cell = Morf::Cell.new(brain: BrainStub.new, sensor: SensorStub.new, clock: @clock)

      @clock.cycle

      _(cell.state).must_equal 1
    end
  end
end
