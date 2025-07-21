# frozen_string_literal: true

require "test_helper"
require "morf/null_cell"

describe Morf::NullCell do
  it "stores the state it is initialized with" do
    cell = Morf::NullCell.new(state: 123)
    _(cell.state).must_equal 123
  end
end
