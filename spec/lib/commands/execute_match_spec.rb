require 'spec_helper'
require 'moneymarket/commands/execute_match'

describe Moneymarket::ExecuteMatch do
  let(:domain) { create_domain btc, clp }
  let(:foo_base_account) { domain.base_account(trigger) }
  let(:foo_quote_account) { domain.quote_account(trigger) }
  let(:bar_base_account) { domain.base_account(other) }
  let(:bar_quote_account) { domain.quote_account(other) }

  let(:trigger) { create_bid btc(10), clp(300_000), fee: 0.1, user: 'foo' }
  let(:other) { create_ask btc(5), clp(300_000), fee: 0.2, user: 'bar', state: :open }
  let(:same_user) { create_ask btc(5), clp(300_000), fee: 0.1, user: 'foo', state: :open }

  before do
    foo_quote_account.deposit(clp(4_000_000))
    foo_base_account.deposit(btc(10))
    foo_base_account.freeze(btc(5))
    bar_base_account.deposit(btc(10))
    bar_base_account.freeze(btc(10))
  end

  def perform(_trigger, _other, _volume)
    match = Moneymarket::Match.new(_trigger, _other, _volume)
    described_class.new(domain: domain, match: match).perform
  end

  it { expect { perform(trigger, other, btc(3)) }.to change { foo_quote_account.total }.by(clp(-900_000)) }
  it { expect { perform(trigger, other, btc(3)) }.to change { foo_base_account.total }.by(btc(2.7)) }
  it { expect { perform(trigger, other, btc(3)) }.to change { bar_quote_account.total }.by(clp(720_000)) }
  it { expect { perform(trigger, other, btc(3)) }.to change { bar_base_account.frozen }.by(btc(-3)) }

  it { expect { perform(trigger, same_user, btc(3)) }.not_to change { foo_quote_account.total } }
  it { expect { perform(trigger, same_user, btc(3)) }.not_to change { foo_base_account.total } }
  it { expect { perform(trigger, same_user, btc(3)) }.to change { foo_base_account.frozen }.by(btc(-3)) }
end
