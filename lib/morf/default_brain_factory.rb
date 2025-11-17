# frozen_string_literal: true

module Morf
  class DefaultBrainFactory
    def initialize(brain_class)
      @brain_class = brain_class
    end

    def create_brain
      @brain_class.new
    end
  end
end
