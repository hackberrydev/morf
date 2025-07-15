require "test_helper"

describe Morf::Cell do
  before do
    @clock = Morf::Clock.new
    @state = 0

    @sensor = Object.new
    def @sensor.sense
      0
    end

    @brain = Object.new
    def @brain.next_state(_state, _neighbourhood)
      1
    end
  end

  describe "initialization" do
    it "initializes with a state" do
      cell = Morf::Cell.new(
        brain: @brain,
        sensor: @sensor,
        clock: @clock,
        state: @state
      )

      _(cell.state).must_equal @state
    end

    it "invokes sensor each cycle" do
      sensor = Minitest::Mock.new
      sensor.expect(:sense, 0)

      Morf::Cell.new(
        brain: @brain,
        sensor: sensor,
        clock: @clock,
        state: @state
      )

      @clock.cycle

      sensor.verify
    end

    it "invokes brain each cycle" do
      brain = Minitest::Mock.new
      brain.expect(:next_state, 1, [@state, 0])

      Morf::Cell.new(
        brain: brain,
        sensor: @sensor,
        clock: @clock,
        state: @state
      )

      @clock.cycle

      brain.verify
    end

    it "moves cell to the new state" do
      cell = Morf::Cell.new(
        brain: @brain,
        sensor: @sensor,
        clock: @clock,
        state: @state
      )

      @clock.cycle

      _(cell.state).must_equal 1
    end
  end
end
