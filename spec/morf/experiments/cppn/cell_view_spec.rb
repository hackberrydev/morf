# frozen_string_literal: true

require "spec_helper"
require "morf/experiments/cppn/cell_view"
require "morf/cell"
require "ruby2d"

RSpec.describe Morf::Experiments::Cppn::CellView do
  subject(:cell_view) do
    described_class.new(cell: cell, cell_size: cell_size, x: x, y: y)
  end

  let(:cell) { instance_double(Morf::Cell) }
  let(:cell_size) { 10 }
  let(:x) { 1 }
  let(:y) { 2 }
  let(:rectangle) { instance_double(Rectangle, color: nil, "color=": nil) }

  before do
    allow(Rectangle).to receive(:new).and_return(rectangle)
  end

  describe "#render" do
    context "when cell state is 0" do
      it "renders a white rectangle" do
        allow(cell).to receive(:state).and_return(0)
        cell_view.render
        expect(rectangle).to have_received(:color=).with("white")
      end
    end

    context "when cell state is 1" do
      it "renders a red rectangle" do
        allow(cell).to receive(:state).and_return(1)
        cell_view.render
        expect(rectangle).to have_received(:color=).with("red")
      end
    end

    context "when cell state is 2" do
      it "renders a green rectangle" do
        allow(cell).to receive(:state).and_return(2)
        cell_view.render
        expect(rectangle).to have_received(:color=).with("green")
      end
    end

    context "when cell state is 3" do
      it "renders a blue rectangle" do
        allow(cell).to receive(:state).and_return(3)
        cell_view.render
        expect(rectangle).to have_received(:color=).with("blue")
      end
    end
  end
end
