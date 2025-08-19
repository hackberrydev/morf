# frozen_string_literal: true

require "spec_helper"
require "morf/cppn/activation_functions"

RSpec.describe Morf::CPPN::ActivationFunctions do
  describe ".sigmoid" do
    it "returns a value between 0 and 1" do
      aggregate_failures do
        expect(described_class.sigmoid(0)).to be_within(0.5).of(0.5)
        expect(described_class.sigmoid(100)).to be_within(0.01).of(1)
        expect(described_class.sigmoid(-100)).to be_within(0.01).of(0)
      end
    end
  end

  describe ".identity" do
    it "returns the input value" do
      aggregate_failures do
        expect(described_class.identity(0)).to eq(0)
        expect(described_class.identity(10)).to eq(10)
        expect(described_class.identity(-10)).to eq(-10)
      end
    end
  end
end
