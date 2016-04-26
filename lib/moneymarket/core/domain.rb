module Moneymarket
  class Domain
    def initialize(_account_manager, _base_currency, _quote_currency, _fee_user)
      raise ArgumentError, 'invalid base currency' unless _base_currency.is_a? Money::Currency
      raise ArgumentError, 'invalid quote currency' unless _quote_currency.is_a? Money::Currency

      @account_manager = _account_manager
      @base_currency = _base_currency
      @quote_currency = _quote_currency
      @fee_user = _fee_user
    end

    def preload_user_balances(_users)
      @account_manager.preload_balances(_users, [@base_currency, @quote_currency])
    end

    def fee_base_account
      @account_manager.account_for(@fee_user, @base_currency)
    end

    def fee_quote_account
      @account_manager.account_for(@fee_user, @quote_currency)
    end

    def base_account(_order)
      @account_manager.account_for(_order.user, @base_currency)
    end

    def quote_account(_order)
      @account_manager.account_for(_order.user, @quote_currency)
    end

    def source_account_for(_order)
      public_send(_order.source_account, _order)
    end

    def destination_account_for(_order)
      public_send(_order.destination_account, _order)
    end
  end
end
