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

  describe ".tanh" do
    it "returns the hyperbolic tangent of the input" do
      aggregate_failures do
        expect(described_class.tanh(0)).to be_within(0.01).of(0)
        expect(described_class.tanh(10)).to be_within(0.01).of(1)
        expect(described_class.tanh(-10)).to be_within(0.01).of(-1)
      end
    end
  end

  describe ".sin" do
    it "returns the sine of the input" do
      aggregate_failures do
        expect(described_class.sin(0)).to be_within(0.01).of(0)
        expect(described_class.sin(Math::PI / 2)).to be_within(0.01).of(1)
        expect(described_class.sin(Math::PI)).to be_within(0.01).of(0)
        expect(described_class.sin(3 * Math::PI / 2)).to be_within(0.01).of(-1)
      end
    end
  end

  describe ".gauss" do
    it "returns the value of the Gaussian function" do
      aggregate_failures do
        expect(described_class.gauss(0)).to be_within(0.01).of(1)
        expect(described_class.gauss(1)).to be_within(0.01).of(Math.exp(-1))
        expect(described_class.gauss(-1)).to be_within(0.01).of(Math.exp(-1))
      end
    end
  end

  describe ".relu" do
    it "returns the rectified linear unit of the input" do
      aggregate_failures do
        expect(described_class.relu(10)).to eq(10)
        expect(described_class.relu(-10)).to eq(0)
        expect(described_class.relu(0)).to eq(0)
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

  describe ".clamped" do
    it "clamps the input value between -1.0 and 1.0" do
      aggregate_failures do
        expect(described_class.clamped(10)).to eq(1.0)
        expect(described_class.clamped(-10)).to eq(-1.0)
        expect(described_class.clamped(0.5)).to eq(0.5)
        expect(described_class.clamped(0)).to eq(0)
      end
    end
  end

  describe ".inv" do
    it "returns the inverse of the input" do
      aggregate_failures do
        expect(described_class.inv(1)).to eq(1)
        expect(described_class.inv(2)).to eq(0.5)
        expect(described_class.inv(-2)).to eq(-0.5)
        expect(described_class.inv(0)).to eq(0)
      end
    end
  end

  describe ".log" do
    it "returns the natural logarithm of the input" do
      aggregate_failures do
        expect(described_class.log(1)).to eq(0)
        expect(described_class.log(Math::E)).to eq(1)
        expect(described_class.log(0)).to eq(0)
        expect(described_class.log(-1)).to eq(0)
      end
    end
  end

  describe ".exp" do
    it "returns the exponential of the input" do
      aggregate_failures do
        expect(described_class.exp(0)).to be_within(0.01).of(1)
        expect(described_class.exp(1)).to be_within(0.01).of(Math::E)
        expect(described_class.exp(-1)).to be_within(0.01).of(1 / Math::E)
      end
    end
  end

  describe ".abs" do
    it "returns the absolute value of the input" do
      aggregate_failures do
        expect(described_class.abs(10)).to eq(10)
        expect(described_class.abs(-10)).to eq(10)
        expect(described_class.abs(0)).to eq(0)
      end
    end
  end

  describe ".hat" do
    it "returns the value of the hat function" do
      aggregate_failures do
        expect(described_class.hat(0)).to be_within(0.01).of(1)
        expect(described_class.hat(0.5)).to be_within(0.01).of(0.5)
        expect(described_class.hat(-0.5)).to be_within(0.01).of(0.5)
        expect(described_class.hat(1)).to be_within(0.01).of(0)
        expect(described_class.hat(-1)).to be_within(0.01).of(0)
        expect(described_class.hat(2)).to be_within(0.01).of(0)
        expect(described_class.hat(-2)).to be_within(0.01).of(0)
      end
    end
  end

  describe ".square" do
    it "returns the square of the input" do
      aggregate_failures do
        expect(described_class.square(2)).to eq(4)
        expect(described_class.square(-2)).to eq(4)
        expect(described_class.square(0)).to eq(0)
      end
    end
  end

  describe ".cube" do
    it "returns the cube of the input" do
      aggregate_failures do
        expect(described_class.cube(2)).to eq(8)
        expect(described_class.cube(-2)).to eq(-8)
        expect(described_class.cube(0)).to eq(0)
      end
    end
  end

  describe "ALL" do
    it "contains all available activation functions" do
      expect(described_class::ALL).to contain_exactly(
        :sigmoid, :tanh, :sin, :gauss, :relu, :identity,
        :clamped, :inv, :log, :exp, :abs, :hat, :square, :cube
      )
    end
  end

  describe ".random" do
    it "returns a random activation function from ALL" do
      random = Random.new(42)
      result = described_class.random(random: random)

      expect(described_class::ALL).to include(result)
    end
  end
end
