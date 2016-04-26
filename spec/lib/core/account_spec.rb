require 'spec_helper'

describe Moneymarket::Account do
  let(:account) { described_class.new(currency: btc, total: btc(2), frozen: btc(0.5)) }

  def expect_event(_total_before, _frozen_before, _total_after, _frozen_after, &_block)
    expect(&_block).to register_event(
      Moneymarket::BalanceChangedEvent,
      total_before: _total_before,
      frozen_before: _frozen_before,
      total_after: _total_after,
      frozen_after: _frozen_after
    )
  end

  describe "available" do
    it { expect(account.available).to eq(btc(1.5)) }
  end

  describe "freeze" do
    it { expect { account.freeze(clp(2)) }.to raise_error }
    it { expect { account.freeze(btc(2)) }.to raise_error }
    it { expect { account.freeze(btc(1)) }.to change { account.frozen }.by(btc(1)) }
    it { expect { account.freeze(btc(1)) }.to change { account.available }.by(btc(-1)) }
    it { expect_event(btc(2.0), btc(0.5), btc(2.0), btc(1.5)) { account.freeze(btc(1)) } }
  end

  describe "unfreeze" do
    it { expect { account.unfreeze(clp(0.6)) }.to raise_error }
    it { expect { account.unfreeze(btc(0.6)) }.to raise_error }
    it { expect { account.unfreeze(btc(0.2)) }.to change { account.frozen }.by(btc(-0.2)) }
    it { expect { account.unfreeze(btc(0.2)) }.to change { account.available }.by(btc(0.2)) }
    it { expect_event(btc(2.0), btc(0.5), btc(2.0), btc(0.3)) { account.unfreeze(btc(0.2)) } }
  end

  describe "deposit" do
    it { expect { account.deposit(clp(2)) }.to raise_error }
    it { expect { account.deposit(btc(1)) }.to change { account.total }.by(btc(1)) }
    it { expect { account.deposit(btc(1)) }.to change { account.available }.by(btc(1)) }
    it { expect_event(btc(2.0), btc(0.5), btc(3.0), btc(0.5)) { account.deposit(btc(1)) } }
  end

  describe "spend" do
    it { expect { account.spend(clp(1)) }.to raise_error }
    it { expect { account.spend(btc(1.6)) }.to raise_error }
    it { expect { account.spend(btc(1)) }.to change { account.total }.by(btc(-1)) }
    it { expect { account.spend(btc(1)) }.to change { account.available }.by(btc(-1)) }
    it { expect_event(btc(2.0), btc(0.5), btc(1.0), btc(0.5)) { account.spend(btc(1)) } }
  end

  describe "spend_frozen" do
    it { expect { account.spend_frozen(clp(1)) }.to raise_error }
    it { expect { account.spend_frozen(btc(0.6)) }.to raise_error }
    it { expect { account.spend_frozen(btc(0.5)) }.not_to change { account.available } }
    it { expect { account.spend_frozen(btc(0.5)) }.to change { account.total }.by(btc(-0.5)) }
    it { expect { account.spend_frozen(btc(0.5)) }.to change { account.frozen }.by(btc(-0.5)) }
    it { expect_event(btc(2.0), btc(0.5), btc(1.7), btc(0.2)) { account.spend_frozen(btc(0.3)) } }
  end
end
