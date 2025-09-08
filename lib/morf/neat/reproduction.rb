# frozen_string_literal: true

require "morf/neat/genome"

module Morf
  module NEAT
    class Reproduction
      attr_reader :next_node_id, :next_innovation_number

      # @param random [Random] The random number generator.
      # @param next_node_id [Integer] The starting ID for new nodes.
      # @param next_innovation_number [Integer] The starting innovation number for new connections.
      # @param weight_range [Range] The range to which connection weights are clamped.
      # @param mutate_add_node_prob [Float] The probability of adding a new node.
      # @param mutate_add_connection_prob [Float] The probability of adding a new connection.
      # @param mutate_weights_prob [Float] The probability of mutating weights.
      # @param new_weight_probability [Float] The probability of assigning a new weight vs. perturbing an existing one.
      # @param add_connection_max_attempts [Integer] The number of times to try adding a connection before giving up.
      def initialize(
        random: Random,
        next_node_id: 0,
        next_innovation_number: 0,
        weight_range: -4.0..4.0,
        mutate_add_node_prob: 0.03,
        mutate_add_connection_prob: 0.05,
        mutate_weights_prob: 0.8,
        new_weight_probability: 0.1,
        add_connection_max_attempts: 10
      )
        @random = random
        @next_node_id = next_node_id
        @next_innovation_number = next_innovation_number
        @weight_range = weight_range
        @mutate_add_node_prob = mutate_add_node_prob
        @mutate_add_connection_prob = mutate_add_connection_prob
        @mutate_weights_prob = mutate_weights_prob
        @new_weight_probability = new_weight_probability
        @add_connection_max_attempts = add_connection_max_attempts
      end

      def mutate(genome)
        if @random.rand < @mutate_add_node_prob
          mutate_add_node(genome)
        end

        if @random.rand < @mutate_add_connection_prob
          mutate_add_connection(genome)
        end

        if @random.rand < @mutate_weights_prob
          mutate_weights(genome)
        end
      end

      def mutate_add_node(genome)
        connection_to_split = genome.connection_genes.sample(random: @random)
        return if connection_to_split.nil?

        connection_to_split.disable

        new_node = Morf::NEAT::NodeGene.new(id: @next_node_id, type: :hidden, activation_function: :sigmoid)
        @next_node_id += 1
        genome.add_node_gene(new_node)

        create_new_connection(genome, connection_to_split.in_node_id, new_node.id, 1.0)
        create_new_connection(genome, new_node.id, connection_to_split.out_node_id, connection_to_split.weight)
      end

      def mutate_add_connection(genome)
        @add_connection_max_attempts.times do
          node1, node2 = genome.node_genes.sample(2, random: @random)
          next if node1.nil? || node2.nil?
          next if genome.connection_exists?(node1.id, node2.id)

          create_new_connection(genome, node1.id, node2.id, @random.rand(-1.0..1.0))
          return
        end
      end

      def mutate_weights(genome)
        genome.connection_genes.each do |connection|
          if @random.rand < @new_weight_probability
            connection.weight = @random.rand(-1.0..1.0)
          else
            connection.weight += @random.rand(-0.1..0.1)
          end
          connection.weight = connection.weight.clamp(@weight_range)
        end
      end

      def crossover(parent1, parent2, fitness1, fitness2)
        child_connection_genes = []
        parent1_connections = parent1.connection_genes.sort_by(&:innovation_number)
        parent2_connections = parent2.connection_genes.sort_by(&:innovation_number)

        i = 0
        j = 0

        while i < parent1_connections.size && j < parent2_connections.size
          conn1 = parent1_connections[i]
          conn2 = parent2_connections[j]

          if conn1.innovation_number == conn2.innovation_number
            child_connection_genes << [conn1, conn2].sample(random: @random)
            i += 1
            j += 1
          elsif conn1.innovation_number < conn2.innovation_number
            child_connection_genes << conn1 if fitness1 >= fitness2
            i += 1
          else
            child_connection_genes << conn2 if fitness2 >= fitness1
            j += 1
          end
        end

        while i < parent1_connections.size
          child_connection_genes << parent1_connections[i] if fitness1 >= fitness2
          i += 1
        end

        while j < parent2_connections.size
          child_connection_genes << parent2_connections[j] if fitness2 >= fitness1
          j += 1
        end

        Morf::NEAT::Genome.new(
          node_genes: parent1.node_genes,
          connection_genes: child_connection_genes
        )
      end

      private

      def create_new_connection(genome, in_node_id, out_node_id, weight)
        new_connection = Morf::NEAT::ConnectionGene.new(
          in_node_id: in_node_id,
          out_node_id: out_node_id,
          weight: weight,
          enabled: true,
          innovation_number: @next_innovation_number
        )
        @next_innovation_number += 1
        genome.add_connection_gene(new_connection)
      end
    end
  end
end
