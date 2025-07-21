# frozen_string_literal: true

module Morf
  module Experiments
    module Dummy
      class Seed
        def state_for(row:, column:)
          0
        end
      end
    end
  end
end
