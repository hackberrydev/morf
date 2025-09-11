# frozen_string_literal: true

require "ruby2d"

module Morf
  module Experiments
    module Dummy
      class CellView
        def initialize(cell:, cell_size:, x:, y:, color_map:)
          @cell = cell
          @cell_size = cell_size
          @x = x
          @y = y
        end

        def render
          rectangle.color = "random"
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
