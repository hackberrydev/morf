# frozen_string_literal: true

require "spec_helper"
require "morf/cppn/node"
require "morf/cppn/activation_functions"

RSpec.describe Morf::CPPN::Node do
  subject(:node) { described_class.new(id: 1, layer: :input, activation_function: :sigmoid) }

  it "has an id" do
    expect(node.id).to eq(1)
  end

  it "has a layer" do
    expect(node.layer).to eq(:input)
  end

  it "has an activation function" do
    expect(node.activation_function).to eq(:sigmoid)
  end
end
