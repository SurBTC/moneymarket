require 'spec_helper'

describe Moneymarket::Order do
  let(:limit) { create_order(btc(1), clp(300_000)) }
  let(:market) { create_order(btc(1)) }
  let(:empty) { create_order(btc(0), clp(300_000)) }
  let(:open) { create_order(btc(0), clp(300_000), state: :open) }

  describe "consume" do
    it { expect { limit.consume(btc(0.5)) }.not_to change { limit.aasm.current_state } }
    it { expect { limit.consume(btc(0.5)) }.to change { limit.volume.cents }.by(-50_000_000) }
    it { expect { limit.consume(btc(1.0)) }.to change { limit.aasm.current_state }.to :traded }
    it { expect { limit.consume(btc(1.1)) }.to raise_error }
  end

  describe "prepare" do
    it { expect { limit.prepare }.to change { limit.aasm.current_state }.to :open }
    it { expect { market.prepare }.to change { market.aasm.current_state }.to :traded }
    it { expect { empty.prepare }.to change { empty.aasm.current_state }.to :traded }
  end

  describe "cancel" do
    it { expect { limit.cancel }.not_to change { limit.aasm.current_state } }
    it { expect { open.cancel }.to change { open.aasm.current_state }.to :canceled }
  end

  describe "base_currency" do
    it { expect(limit.base_currency).to eq btc }
  end

  describe "quote_currency" do
    it { expect(limit.quote_currency).to eq clp }
  end
end
