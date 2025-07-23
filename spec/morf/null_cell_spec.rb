# frozen_string_literal: true

require "spec_helper"
require "morf/null_cell"

RSpec.describe Morf::NullCell do
  it "stores the state it is initialized with" do
    cell = described_class.new(state: 123)
    expect(cell.state).to eq(123)
  end
end
