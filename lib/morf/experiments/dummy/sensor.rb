module Morf
  module Experiments
    module Dummy
      class Sensor
        def initialize(grid:, row:, column:)
          @grid = grid
          @row = row
          @column = column
        end

        def sense
          [@row, @column]
        end
      end
    end
  end
end
