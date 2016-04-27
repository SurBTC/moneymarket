require 'spec_helper'
require 'moneymarket/commands/match_order_to_slope'

describe Moneymarket::MatchOrderToSlope do
  let(:slope) { Moneymarket::AskSlope.new }
  let(:limit_order) { create_bid(btc(10), clp(300_000), timestamp: 104) }
  let(:market_order) { create_bid(btc(20), timestamp: 104) }

  def perform(_order)
    described_class.new(slope: slope, order: _order).perform
  end

  it { expect(perform(limit_order).count).to eq(0) }
  it { expect(perform(market_order).count).to eq(0) }

  context "given some existing orders" do
    before do
      slope.add create_ask(btc(2), clp(290_000), timestamp: 100)
      slope.add create_ask(btc(3), clp(291_000), timestamp: 101)
      slope.add create_ask(btc(6), clp(293_000), timestamp: 102)
      slope.add create_ask(btc(2), clp(294_000), timestamp: 103)
      slope.add create_ask(btc(10), clp(295_000), timestamp: 103)
    end

    it { expect(perform(limit_order).to_a.count).to eq 3 }
    it { expect(perform(limit_order).to_a.first.volume).to eq btc(2) }
    it { expect(perform(limit_order).to_a.last.volume).to eq btc(5) }

    it { expect(perform(market_order).to_a.count).to eq 5 }
    it { expect(perform(market_order).to_a.last.volume).to eq btc(7) }
  end
end
