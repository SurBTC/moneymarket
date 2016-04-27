require 'spec_helper'
require 'moneymarket/commands/limit_matches'

describe Moneymarket::LimitMatches do
  def perform(_limit)
    described_class.new(matches: matches, destination_limit: _limit).perform
  end

  context "when limiting asks" do
    let(:trigger) { create_bid btc(10) }

    let(:matches) do
      [
        Moneymarket::Match.new(trigger, create_ask(btc(2), clp(300_000)), btc(2)),
        Moneymarket::Match.new(trigger, create_ask(btc(3), clp(400_000)), btc(3)),
        Moneymarket::Match.new(trigger, create_ask(btc(6), clp(500_000)), btc(6)),
        Moneymarket::Match.new(trigger, create_ask(btc(6), clp(600_000)), btc(6))
      ]
    end

    it { expect(perform(clp(500_000)).count).to eq 1 }
    it { expect(perform(clp(1_000_000)).count).to eq 2 }
    it { expect(perform(clp(1_000_000)).last.volume).to eq btc(1) }
    it { expect(perform(clp(10_000_000)).count).to eq 4 }
    it { expect(perform(clp(10_000_000)).last.volume).to eq btc(6) }
  end

  context "when limiting bids" do
    let(:trigger) { create_ask btc(100) }

    let(:matches) do
      [
        Moneymarket::Match.new(trigger, create_bid(btc(6), clp(600_000)), btc(6)),
        Moneymarket::Match.new(trigger, create_bid(btc(6), clp(500_000)), btc(6)),
        Moneymarket::Match.new(trigger, create_bid(btc(3), clp(400_000)), btc(3)),
        Moneymarket::Match.new(trigger, create_bid(btc(2), clp(300_000)), btc(2))
      ]
    end

    it { expect(perform(btc(5)).count).to eq 1 }
    it { expect(perform(btc(10)).count).to eq 2 }
    it { expect(perform(btc(10)).last.volume).to eq btc(4) }
    it { expect(perform(btc(20)).count).to eq 4 }
    it { expect(perform(btc(20)).last.volume).to eq btc(2) }
  end
end

