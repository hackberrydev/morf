# frozen_string_literal: true

module Morf
  module NEAT
    module Fitness
      class PatternTarget
        attr_reader :target_pattern

        def initialize(target_pattern)
          @target_pattern = target_pattern
        end

        def evaluate(grid)
          correct_cells = 0
          total_cells = grid.rows * grid.columns

          (0...grid.rows).each do |row|
            (0...grid.columns).each do |column|
              if grid.cell(row: row, column: column).state == @target_pattern[row][column]
                correct_cells += 1
              end
            end
          end

          correct_cells.to_f / total_cells
        end
      end
    end
  end
end
