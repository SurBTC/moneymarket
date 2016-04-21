require 'spec_helper'

describe Moneymarket::Ask do
  let(:limit) { create_ask(btc(2), clp(300_000)) }

  describe "source_required_amount" do
    it { expect(limit.source_required_amount).to eq(btc(2)) }
    it { expect(limit.source_required_amount(for_volume: btc(0.5))).to eq(btc(0.5)) }
  end

  describe "destination_collected_amount" do
    it { expect(limit.destination_collected_amount).to eq(clp(600_000)) }
    it { expect(limit.destination_collected_amount(for_volume: btc(1.5))).to eq(clp(450_000)) }
  end

  describe "volume_required_to_collect" do
    it { expect(limit.volume_required_to_collect(clp(600_000))).to eq(btc(2)) }
  end
end
