module Moneymarket
  class BalanceChangedEvent < Event
    attr_accessor :account, :reason, :total_before, :frozen_before, :total_after, :frozen_after
  end
end
