require 'spec_helper'

describe Moneymarket::AskSlope do
  let(:slope) { described_class.new }

  context "loaded with some orders" do
    let(:order_1) { create_bid(btc(10), clp(300_000), timestamp: 1) }
    let(:order_2) { create_bid(btc(10), clp(301_000), timestamp: 2) }
    let(:order_3) { create_bid(btc(10), clp(295_000), timestamp: 3) }
    let(:order_4) { create_bid(btc(10), clp(295_000), timestamp: 4) }
    let(:order_5) { create_bid(btc(10), clp(295_000), timestamp: 5) }

    before do
      slope.add order_1
      slope.add order_2
      slope.add order_4
      slope.add order_3
      slope.add order_5
    end

    describe "Enumerable" do
      it "returns orders in execution order (low to high limit, FIFO if equal)" do
        expect(slope.to_a).to eq([order_3, order_4, order_5, order_1, order_2])
      end
    end
  end
end
