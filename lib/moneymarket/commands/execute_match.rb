module Moneymarket
  class ExecuteMatch < Command.new(:domain, :match)
    def perform
      EventManager.register(event) do
        execute_exchange
        execute_fees unless same_user?
      end
    end

    private

    def execute_exchange
      bid_quote_account.unfreeze(quote, :tx) unless bid.new?
      ask_base_account.unfreeze(volume, :tx) unless ask.new?

      transfer quote, from: bid_quote_account, to: ask_quote_account, as: :tx # 2 events
      transfer volume, from: ask_base_account, to: bid_base_account, as: :tx # 2 events

      bid.consume volume # 1 event
      ask.consume volume # 1 event
    end

    def execute_fees
      transfer bid_fee, from: bid_base_account, to: fee_base_account, as: :fee # 2 events
      transfer ask_fee, from: ask_quote_account, to: fee_quote_account, as: :fee # 2 events
    end

    def event
      @event ||= TransactionExecutedEvent.new.tap do |ev|
        ev.bid = bid.ref
        ev.ask = ask.ref
        ev.volume = volume
        ev.quote = quote
        ev.bid_fee = bid_fee
        ev.ask_fee = ask_fee
      end
    end

    def bid
      match.bid
    end

    def ask
      match.ask
    end

    def same_user?
      bid.user == ask.user
    end

    def volume
      match.volume
    end

    def quote
      @quote ||= Calculator.quote(volume: volume, unit_price: match.price_paid)
    end

    def bid_fee
      @bid_fee ||= Calculator.fee(amount: volume, percent: bid.fee)
    end

    def ask_fee
      @ask_fee ||= Calculator.fee(amount: quote, percent: ask.fee)
    end

    def transfer(_amount, from: nil, to: nil, as: nil)
      from.spend _amount, as
      to.deposit _amount, as
    end

    def bid_base_account
      domain.base_account match.bid
    end

    def ask_base_account
      domain.base_account match.ask
    end

    def bid_quote_account
      domain.quote_account match.bid
    end

    def ask_quote_account
      domain.quote_account match.ask
    end

    def fee_base_account
      domain.fee_base_account
    end

    def fee_quote_account
      domain.fee_quote_account
    end
  end
end
