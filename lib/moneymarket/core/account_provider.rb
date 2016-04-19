module Moneymarket
  class AccountProvider
    def initialize
      @accounts = {}
    end

    def reset
      @accounts = {}
    end

    def exchange_account_for(_currency)
      assert_implemented :exchange_account_for
    end

    def account_for(_user_id, _currency)
      assert_implemented :account_for
    end

    def preload_user_balances(_users, _currencies)
      assert_implemented :preload_user_balances
    end

    def preload_balances(_order)
      _order.base_balance = fetch_balance(_order.account_id, _order.base_currency)
      _order.quote_balance = fetch_balance(_order.account_id,  _order.quote_currency)
    end

    private

    def assert_implemented(_name)
      raise NotImplementedError, "#{_name} is not implemented"
    end
  end
end
