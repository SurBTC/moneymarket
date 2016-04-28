require 'spec_helper'

describe Moneymarket::Calculator do
  let(:calculator) { described_class }

  describe "quote" do
    it { expect(calculator.quote(volume: btc(10), unit_price: clp(300_000))).to eq clp(3_000_000)}
    it { expect(calculator.quote(volume: btc(0.01), unit_price: clp(300_000))).to eq clp(3_000)}
  end

  describe "volume" do
    it do
      expect(calculator.volume(
        quote: clp(600_000),
        unit_price: clp(300_000),
        unit_currency: btc()
      )).to eq btc(2)
    end
  end

  describe "fee" do
    it { expect(calculator.fee(amount: clp(10), percent: 0.3)).to eq(clp(3)) }
    it { expect(calculator.fee(amount: clp(1), percent: 0.009)).to eq(clp(0)) }
  end
end
