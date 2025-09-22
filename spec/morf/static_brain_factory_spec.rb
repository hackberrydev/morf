# frozen_string_literal: true

require "spec_helper"
require "morf/static_brain_factory"

RSpec.describe Morf::StaticBrainFactory do
  subject(:factory) { described_class.new(brain) }

  let(:brain) { double("brain") }

  describe "#create_brain" do
    it "returns the brain instance it was initialized with" do
      expect(factory.create_brain).to be(brain)
    end

    it "returns the same instance on multiple calls" do
      brain1 = factory.create_brain
      brain2 = factory.create_brain
      expect(brain1).to be(brain2)
    end
  end
end
