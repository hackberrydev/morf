# frozen_string_literal: true

module Morf
  module NEAT
    module Mutation
      class Weights
        def initialize(genome, random:, new_weight_prob:, weight_range:)
          @genome = genome
          @random = random
          @new_weight_prob = new_weight_prob
          @weight_range = weight_range
        end

        def call
          @genome.connection_genes.each do |connection|
            if @random.rand < @new_weight_prob
              connection.weight = @random.rand(-1.0..1.0)
            else
              connection.weight += @random.rand(-0.1..0.1)
            end
            connection.weight = connection.weight.clamp(@weight_range)
          end
        end
      end
    end
  end
end
