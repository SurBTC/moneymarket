require 'spec_helper'

describe Moneymarket::BidSlope do
  let(:slope) { described_class.new }
  let(:order) { create_bid(btc(10), clp(300_000), timestamp: 1) }

  describe "add" do
    it { expect { slope.add(order) }.to change { slope.count }.by(1) }
  end

  describe "remove" do
    it { expect { slope.add(order) }.to change { slope.count }.by(1) }
  end

  context "loaded with some orders" do
    let(:order_2) { create_bid(btc(10), clp(301_000), timestamp: 2) }
    let(:order_3) { create_bid(btc(10), clp(295_000), timestamp: 3) }
    let(:order_4) { create_bid(btc(10), clp(295_000), timestamp: 4) }
    let(:order_5) { create_bid(btc(10), clp(295_000), timestamp: 5) }

    before do
      slope.add order
      slope.add order_2
      slope.add order_4
      slope.add order_3
      slope.add order_5
    end

    describe "Enumerable" do
      it "returns orders in execution order (high to low limit, FIFO if equal)" do
        expect(slope.to_a).to eq([order_2, order, order_3, order_4, order_5])
      end
    end

    describe "each_until_limit" do
      it "returns orders in execution order until limit is reached" do
        expect(slope.each_until_limit(clp(301_000)).to_a).to eq([order_2])
        expect(slope.each_until_limit(clp(296_000)).to_a).to eq([order_2, order])
      end
    end
  end
end
