require "spec_helper"
require "morf/experiments/cppn/cell_view"

RSpec.describe Morf::Experiments::CPPN::CellView do
  subject(:cell_view) do
    described_class.new(
      cell: cell,
      cell_size: 10,
      x: 0,
      y: 0,
      color_map: color_map
    )
  end

  let(:cell) { double("Cell", state: 1) }
  let(:color_map) { {0 => "black", 1 => "white"} }
  let(:rectangle) { double("Rectangle") }

  before do
    allow(Rectangle).to receive(:new).and_return(rectangle)
    allow(rectangle).to receive(:color=)
  end

  describe "#render" do
    it "sets the rectangle color based on the cell state and color map" do
      cell_view.render
      expect(rectangle).to have_received(:color=).with("white")
    end
  end
end
