# frozen_string_literal: true

module Morf
  # Represents a cell that is always dead and lives outside the grid.
  class NullCell
    attr_reader :state

    def initialize(state:)
      @state = state
    end
  end
end
