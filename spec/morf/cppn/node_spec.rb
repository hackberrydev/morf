# frozen_string_literal: true

require "spec_helper"
require "morf/cppn/node"

RSpec.describe Morf::CPPN::Node do
  subject(:node) { described_class.new(id: 1, layer: :input) }

  it "has an id" do
    expect(node.id).to eq(1)
  end

  it "has a layer" do
    expect(node.layer).to eq(:input)
  end
end
