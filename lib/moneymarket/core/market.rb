module Moneymarket
  class Market
    attr_reader :account_provider

    def initialize(_base_currency, _quote_currency, account_provider = nil)
      @base_currency = _base_currency
      @quote_currency = _quote_currency
      @account_provider = account_provider
    end

    def preload_user_balances(_users)
      account_provider.preload_balances(_users, [_base_currency, _quote_currency])
    end

    def exchange_base_account
      account_provider.exchange_account_for base_currency
    end

    def exchange_quote_account
      account_provider.exchange_account_for quote_currency
    end

    def base_account_for(_order)
      account_provider.account_for(_order.user_id, base_currency)
    end

    def quote_account_for(_order)
      account_provider.account_for(_order.user_id, quote_currency)
    end

    def source_account_for(_order)
      public_send(_order.source_account, _order)
    end

    def destination_account_for(_order)
      public_send(_order.destination_account, _order)
    end
  end
end
