require "morf/cell"

describe Morf::Cell do
  before do
    @brain = Minitest::Mock.new
    @brain.expect(:next_state, 1, [0])

    @sensor = Minitest::Mock.new
    @sensor.expect(:sense, 0)

    @clock = Morf::Clock.new
  end

  describe "initialization" do
    it "invokes sensor each cycle" do
      Morf::Cell.new(brain: @brain, sensor: @sensor, clock: @clock)

      @clock.cycle

      @sensor.verify
    end

    it "invokes brain each cycle" do
      Morf::Cell.new(brain: @brain, sensor: @sensor, clock: @clock)

      @clock.cycle

      @brain.verify
    end

    it "moves cell to the new state" do
      cell = Morf::Cell.new(brain: @brain, sensor: @sensor, clock: @clock)

      @clock.cycle

      _(cell.state).must_equal 1
    end
  end
end
