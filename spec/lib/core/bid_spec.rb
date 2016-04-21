require 'spec_helper'

describe Moneymarket::Bid do
  let(:limit) { create_bid(btc(1), clp(300_000)) }

  describe "source_required_amount" do
    it { expect(limit.source_required_amount).to eq(clp(300_000)) }
    it { expect(limit.source_required_amount(for_volume: btc(0.5))).to eq(clp(150_000)) }
  end

  describe "destination_collected_amount" do
    it { expect(limit.destination_collected_amount).to eq(btc(1)) }
    it { expect(limit.destination_collected_amount(for_volume: btc(0.5))).to eq(btc(0.5)) }
  end

  describe "volume_required_to_collect" do
    it { expect(limit.volume_required_to_collect(btc(2))).to eq(btc(2)) }
  end
end
