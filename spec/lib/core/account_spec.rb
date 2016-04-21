require 'spec_helper'

describe Moneymarket::Account do
  let(:account) { described_class.new(currency: btc, total: btc(2), frozen: btc(0.5)) }

  describe "available" do
    it { expect(account.available).to eq(btc(1.5)) }
  end

  describe "freeze" do
    it { expect { account.freeze(clp(2)) }.to raise_error }
    it { expect { account.freeze(btc(2)) }.to raise_error }
    it { expect { account.freeze(btc(1)) }.to change { account.frozen }.by(btc(1)) }
    it { expect { account.freeze(btc(1)) }.to change { account.available }.by(btc(-1)) }
  end

  describe "unfreeze" do
    it { expect { account.unfreeze(clp(0.6)) }.to raise_error }
    it { expect { account.unfreeze(btc(0.6)) }.to raise_error }
    it { expect { account.unfreeze(btc(0.2)) }.to change { account.frozen }.by(btc(-0.2)) }
    it { expect { account.unfreeze(btc(0.2)) }.to change { account.available }.by(btc(0.2)) }
  end

  describe "deposit" do
    it { expect { account.deposit(clp(2)) }.to raise_error }
    it { expect { account.deposit(btc(1)) }.to change { account.total }.by(btc(1)) }
    it { expect { account.deposit(btc(1)) }.to change { account.available }.by(btc(1)) }
  end

  describe "withdraw" do
    it { expect { account.withdraw(clp(1)) }.to raise_error }
    it { expect { account.withdraw(btc(1.6)) }.to raise_error }
    it { expect { account.withdraw(btc(1)) }.to change { account.total }.by(btc(-1)) }
    it { expect { account.withdraw(btc(1)) }.to change { account.available }.by(btc(-1)) }
  end
end
