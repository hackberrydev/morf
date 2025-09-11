# frozen_string_literal: true

require "ruby2d"

module Morf
  module Experiments
    module GameOfLife
      class CellView
        def initialize(cell:, cell_size:, x:, y:, color_map:)
          @cell = cell
          @cell_size = cell_size
          @x = x
          @y = y
          @color_map = color_map
        end

        def render
          rectangle.color = @color_map[@cell.state]
        end

        private

        def rectangle
          @rectangle ||= Rectangle.new(
            x: @x * @cell_size,
            y: @y * @cell_size,
            width: @cell_size,
            height: @cell_size
          )
        end
      end
    end
  end
end
