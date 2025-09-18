require "spec_helper"
require "morf/grid_view"
require "morf/grid"
require "morf/clock"
require "morf/default_brain_factory"
require "ruby2d"

RSpec.describe Morf::GridView do
  subject(:grid_view) do
    described_class.new(
      clock: clock,
      grid: grid,
      cell_view_class: cell_view_class,
      cell_size: 5,
      time_limit: 10,
      color_map: color_map
    )
  end

  let(:clock) { Morf::Clock.new }
  let(:grid) do
    Morf::Grid.new(
      brain_factory: Morf::DefaultBrainFactory.new(brain_class),
      sensor_class: sensor_class,
      clock: clock,
      rows: 1,
      columns: 1,
      seed: seed
    )
  end
  let(:brain_class) { double("Brain", new: double("BrainInstance")) }
  let(:sensor_class) { double("Sensor", new: double("SensorInstance")) }
  let(:seed) { double("Seed", default_state: 0, state_for: 0) }
  let(:cell_view_class) { double("CellView", new: cell_view) }
  let(:cell_view) { double("CellViewInstance") }
  let(:color_map) { {0 => "black", 1 => "white"} }

  before do
    # Mocking the cell to avoid errors
    allow(Morf::Cell).to receive(:new).and_return(double("Cell", state: 0))
    allow(Ruby2D::Window).to receive(:set)
    allow(Ruby2D::Window).to receive(:update)
    allow(Ruby2D::Window).to receive(:render)
    allow(Ruby2D::Window).to receive(:show)

    # We need to call private method `cell_views` to trigger the instantiation of cell views
    grid_view.send(:cell_views)
  end

  it "passes the color_map to the cell view" do
    expect(cell_view_class).to have_received(:new).with(
      hash_including(color_map: color_map)
    )
  end
end
