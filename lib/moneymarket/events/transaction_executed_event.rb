module Moneymarket
  class TransactionExecutedEvent < Event
    attr_accessor :bid, :ask, :volume, :quote, :bid_fee, :ask_fee
  end
end