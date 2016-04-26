require 'spec_helper'
require 'moneymarket/commands/check_order_solvent'

describe Moneymarket::CheckOrderSolvent do
  let(:domain) { create_domain(btc, clp) }
  let(:bid) { create_bid(btc(10), clp(300_000), user: 'foo') }
  let(:ask) { create_ask(btc(10), clp(300_000), user: 'foo') }

  def perform(_order)
    described_class.new(domain: domain, order: _order).perform
  end

  context "for insolvent limit order" do
    before do
      domain.quote_account(bid).deposit(clp(2_999_999))
      domain.base_account(ask).deposit(btc(9.9))
    end

    it { expect(perform(bid)).to be false }
    it { expect(perform(ask)).to be false }
  end

  context "for solvent limit order" do
    before do
      domain.quote_account(bid).deposit(clp(30_000_000))
      domain.base_account(ask).deposit(btc(10))
    end

    it { expect(perform(bid)).to be true }
    it { expect(perform(ask)).to be true }
  end

  context "for market order" do
    let(:order) { create_ask(btc(10), user: 'foo') }

    it { expect(perform(order)).to be true }
  end
end
