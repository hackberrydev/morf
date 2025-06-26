#!/usr/bin/env ruby
# frozen_string_literal: true

require 'ruby2d'

CELL_SIZE = 5
ROWS, COLS = 100, 100

set title: 'Morphogenesis Grid',
    width: COLS * CELL_SIZE, height: ROWS * CELL_SIZE

(0...ROWS).each do |y|
  (0...COLS).each do |x|
    Rectangle.new(
      x: x * CELL_SIZE, y: y * CELL_SIZE,
      width: CELL_SIZE, height: CELL_SIZE,
      color: 'gray'
    )
  end
end

show