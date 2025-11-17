# frozen_string_literal: true

require "spec_helper"
require "morf/neat/connection_gene"

RSpec.describe Morf::NEAT::ConnectionGene do
  subject(:connection_gene) do
    described_class.new(
      in_node_id: 1,
      out_node_id: 2,
      weight: 0.5,
      enabled: true,
      innovation_number: 1
    )
  end

  describe "#disable" do
    it "disables the gene" do
      connection_gene.disable

      expect(connection_gene).not_to be_enabled
    end
  end
end
