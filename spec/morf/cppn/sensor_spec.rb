# frozen_string_literal: true

require "spec_helper"
require "morf/cppn/sensor"
require "morf/grid"
require "morf/cell"

RSpec.describe Morf::CPPN::Sensor do
  subject(:sensor) { described_class.new(grid: grid, row: 1, column: 1) }

  let(:grid) do
    instance_double(Morf::Grid, cell: instance_double(Morf::Cell, state: 1))
  end

  describe "#sense" do
    it "returns the states of the Moore neighborhood" do
      expect(sensor.sense).to eq([1, 1, 1, 1, 1, 1, 1, 1])
    end
  end
end
