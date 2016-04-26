module Moneymarket
  class CheckOrderSolvent < Command.new(:domain, :order)
    def perform
      return true if order.market_order?
      source_available_amount >= order.source_required_amount
    end

    private

    def source_available_amount
      domain.source_account_for(order).available
    end
  end
end