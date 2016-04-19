class ApplyMatch < Command.new(:market, :match)
  def perform
    cache_balances :before
    execute_exchange
    execute_fees unless same_user?
    cache_balances :after
    event
  end

  private

  def execute_exchange
    bid_quote_account.unfreeze quote unless bid.new?
    ask_base_account.unfreeze volume unless ask.new?

    bid.consume volume
    ask.consume volume

    transfer quote, from: bid_quote_account, to: ask_quote_account
    transfer volume, from: ask_base_account, to: bid_base_account

    event.quote = quote
  end

  def execute_fees
    transfer bid_fee, from: bid_base_account, to: exchange_base_account
    transfer ask_fee, from: ask_quote_account, to: exchange_quote_account

    event.bid_fee = bid_fee
    event.ask_fee = ask_fee
  end

  def cache_balances(_which)
    event.public_send("bid_base_account_#{_which}=", bid_base_account.clone)
    event.public_send("bid_quote_account_#{_which}=", bid_quote_account.clone)
    event.public_send("ask_base_account_#{_which}=", ask_base_account.clone)
    event.public_send("ask_quote_account_#{_which}=", ask_quote_account.clone)
    event.public_send("ex_base_account_#{_which}=", exchange_base_account.clone)
    event.public_send("ex_quote_account_#{_which}=", exchange_quote_account.clone)
  end

  def event
    @event ||= Events::TransactionExecuted.new.tap do |ev|
      ev.bid = bid.ref
      ev.ask = ask.ref
      ev.volume = volume
      ev.quote = quote
    end
  end

  def bid
    match.bid
  end

  def ask
    match.ask
  end

  def volume
    match.volume
  end

  def quote
    @quote ||= begin
      CalculateQuote.new(volume: volume, unit_price: match.price_paid).perform
    end
  end

  def transfer(_amount, from: nil, to: nil)
    from.withdraw _amount
    to.deposit _amount
  end

  def bid_base_account
    market.base_account_for match.bid
  end

  def ask_base_account
    market.base_account_for match.ask
  end

  def bid_quote_account
    market.quote_account_for match.bid
  end

  def ask_quote_account
    market.quote_account_for match.ask
  end

  def same_user?
    bid.user == ask.user
  end

  def bid_fee
    @bid_fee ||= CalculateFee.new(order: bid, collected_amount: volume).perform
  end

  def ask_fee
    @ask_fee ||= CalculateFee.new(order: ask, collected_amount: quote).perform
  end

  def exchange_base_account
    market.exchange_base_account
  end

  def exchange_quote_account
    market.exchange_quote_account
  end
end
