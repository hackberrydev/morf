# frozen_string_literal: true

require "spec_helper"
require "morf/experiments/neat/offspring_allocator"
require "morf/neat/genome"

RSpec.describe Morf::Experiments::NEAT::OffspringAllocator do
  let(:population_size) { 100 }
  let(:allocator) { described_class.new(population_size: population_size) }

  describe "#allocate" do
    context "when all species have zero fitness" do
      it "allocates offspring evenly across species" do
        genome1 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 0.0)
        genome2 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 0.0)
        genome3 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 0.0)

        species = [
          [genome1],
          [genome2],
          [genome3]
        ]

        counts = allocator.allocate(species)

        aggregate_failures do
          expect(counts.sum).to eq(population_size)
          expect(counts).to eq([34, 33, 33])
        end
      end

      it "distributes remainders to first species when population doesn't divide evenly" do
        genome1 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 0.0)
        genome2 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 0.0)

        species = [
          [genome1],
          [genome2]
        ]

        counts = allocator.allocate(species)

        aggregate_failures do
          expect(counts.sum).to eq(population_size)
          expect(counts).to eq([50, 50])
        end
      end
    end

    context "when species have non-zero fitness" do
      it "allocates offspring proportionally to species fitness" do
        genome1 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 10.0)
        genome2 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 20.0)
        genome3 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 30.0)

        species = [
          [genome1],
          [genome2],
          [genome3]
        ]

        counts = allocator.allocate(species)

        aggregate_failures do
          expect(counts.sum).to eq(population_size)
          expect(counts[0]).to be_within(1).of(17) # ~16.67
          expect(counts[1]).to be_within(1).of(33) # ~33.33
          expect(counts[2]).to be_within(1).of(50) # 50.00
        end
      end

      it "handles multiple genomes per species correctly" do
        genome1a = instance_double(Morf::NEAT::Genome, adjusted_fitness: 5.0)
        genome1b = instance_double(Morf::NEAT::Genome, adjusted_fitness: 5.0)
        genome2 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 20.0)

        species = [
          [genome1a, genome1b], # Total: 10.0
          [genome2]              # Total: 20.0
        ]

        counts = allocator.allocate(species)

        aggregate_failures do
          expect(counts.sum).to eq(population_size)
          expect(counts[0]).to be_within(1).of(33) # ~33.33
          expect(counts[1]).to be_within(1).of(67) # ~66.67
        end
      end

      it "distributes remainders to species with highest fractional parts" do
        genome1 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 1.0)
        genome2 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 1.0)
        genome3 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 1.0)

        species = [
          [genome1],
          [genome2],
          [genome3]
        ]

        counts = allocator.allocate(species)

        aggregate_failures do
          expect(counts.sum).to eq(population_size)
          expect(counts).to eq([34, 33, 33])
        end
      end

      it "ensures total offspring count equals population size" do
        genome1 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 7.3)
        genome2 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 2.1)
        genome3 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 4.6)

        species = [
          [genome1],
          [genome2],
          [genome3]
        ]

        counts = allocator.allocate(species)

        expect(counts.sum).to eq(population_size)
      end
    end

    context "with different population sizes" do
      it "works with small populations" do
        small_allocator = described_class.new(population_size: 10)
        genome1 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 1.0)
        genome2 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 1.0)

        species = [[genome1], [genome2]]
        counts = small_allocator.allocate(species)

        aggregate_failures do
          expect(counts.sum).to eq(10)
          expect(counts).to eq([5, 5])
        end
      end

      it "works with large populations" do
        large_allocator = described_class.new(population_size: 1000)
        genome1 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 1.0)
        genome2 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 2.0)
        genome3 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 3.0)

        species = [[genome1], [genome2], [genome3]]
        counts = large_allocator.allocate(species)

        aggregate_failures do
          expect(counts.sum).to eq(1000)
          expect(counts[0]).to be_within(1).of(167)  # ~16.67%
          expect(counts[1]).to be_within(1).of(333)  # ~33.33%
          expect(counts[2]).to be_within(1).of(500)  # 50%
        end
      end
    end

    context "with edge cases" do
      it "handles a single species" do
        genome1 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 10.0)
        species = [[genome1]]

        counts = allocator.allocate(species)

        expect(counts).to eq([population_size])
      end

      it "handles species with very different fitness values" do
        genome1 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 0.1)
        genome2 = instance_double(Morf::NEAT::Genome, adjusted_fitness: 100.0)

        species = [[genome1], [genome2]]
        counts = allocator.allocate(species)

        aggregate_failures do
          expect(counts.sum).to eq(population_size)
          expect(counts[0]).to be < 5  # Very small fitness
          expect(counts[1]).to be > 95 # Very large fitness
        end
      end
    end
  end
end
