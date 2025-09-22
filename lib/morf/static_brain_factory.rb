# frozen_string_literal: true

module Morf
  class StaticBrainFactory
    def initialize(brain)
      @brain = brain
    end

    def create_brain
      @brain
    end
  end
end
