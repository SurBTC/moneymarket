require 'spec_helper'

describe Moneymarket::AccountManager do
  let(:manager) { described_class.new }

  describe "account_for" do
    it { expect(manager.account_for('foo', btc)).to be_a Moneymarket::Account }
    it { expect(manager.account_for('foo', btc).currency).to eq btc }
    it { expect(manager.account_for('foo', btc).frozen).to eq btc(0) }
    it { expect(manager.account_for('foo', btc).total).to eq btc(0) }
    it { expect(manager.account_for('foo', btc).user).to eq 'foo' }
    it { expect(manager.account_for('foo', btc)).to eq manager.account_for('foo', btc) }
    it { expect(manager.account_for('foo', btc)).not_to eq manager.account_for('foo', clp) }
    it { expect(manager.account_for('foo', btc)).not_to eq manager.account_for('bar', btc) }

    context "returned account has been modified" do
      before { manager.account_for('foo', btc).deposit(btc(10)) }
      it { expect(manager.account_for('foo', btc).frozen).to eq btc(0) }
      it { expect(manager.account_for('foo', btc).total).to eq btc(10) }
    end
  end
end
