class CheckOrderSolvent < Command.new(:market, :order)
  def perform
    return true if order.market_order?
    source_available_amount >= order.required_amount
  end

  private

  def source_available_amount
    market.source_account_for(order).available
  end
end
