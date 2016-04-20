require 'spec_helper'

describe Moneymarket::Assertions do
  let(:assertions) { described_class }

  describe "valid_money" do
    it { expect { assertions.valid_money(btc(10)) }.not_to raise_error }
    it { expect { assertions.valid_money(btc(10), currency: btc) }.not_to raise_error }
    it { expect { assertions.valid_money(btc(-10), negative: true) }.not_to raise_error }
    it { expect { assertions.valid_money(btc(10), currency: clp) }.to raise_error }
    it { expect { assertions.valid_money(btc(-10)) }.to raise_error }
    it { expect { assertions.valid_money(10) }.to raise_error }
  end

  describe "valid_fee" do
    it { expect { assertions.valid_fee(0.2) }.not_to raise_error }
    it { expect { assertions.valid_fee(-0.2, negative: true) }.not_to raise_error }
    it { expect { assertions.valid_fee(1.2) }.to raise_error }
    it { expect { assertions.valid_fee(-0.2) }.to raise_error }
  end
end
