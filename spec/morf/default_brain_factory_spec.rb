require "spec_helper"
require "morf/default_brain_factory"

RSpec.describe Morf::DefaultBrainFactory do
  subject(:factory) { described_class.new(brain_class) }

  let(:brain_class) { double("BrainClass", new: brain_instance) }
  let(:brain_instance) { double("BrainInstance") }

  describe "#create_brain" do
    it "creates a new brain instance from the brain class" do
      expect(factory.create_brain).to eq(brain_instance)
    end
  end
end
