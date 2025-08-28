# frozen_string_literal: true

require "ruby2d"

module Morf
  module Experiments
    module CPPN
      class CellView
        COLORS = {
          0 => "white",
          1 => "red",
          2 => "green",
          3 => "blue"
        }.freeze

        def initialize(cell:, cell_size:, x:, y:)
          @cell = cell
          @cell_size = cell_size
          @x = x
          @y = y
        end

        def render
          rectangle.color = COLORS[@cell.state]
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
