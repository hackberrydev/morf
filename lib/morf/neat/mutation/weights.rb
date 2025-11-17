# frozen_string_literal: true

module Morf
  module NEAT
    module Mutation
      class Weights
        def initialize(genome, mutation_strategy:)
          @genome = genome
          @mutation_strategy = mutation_strategy
        end

        def call
          @genome.connection_genes.each do |connection|
            connection.weight = @mutation_strategy.mutate_weight(connection.weight)
          end
        end
      end
    end
  end
end
