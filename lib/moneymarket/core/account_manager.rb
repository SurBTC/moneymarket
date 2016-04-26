module Moneymarket
  class AccountManager
    def initialize
      @users = {}
    end

    def preload_user_balances(_users, _currencies)
      # Nothing for default manager
    end

    def account_for(_user, _currency)
      user = @users[_user]
      user = @users[_user] = {} if user.nil?
      account = user[_currency.to_s]
      account = user[_currency.to_s] = new_account(_user, _currency) if account.nil?
      account
    end

    private

    def new_account(_user, _currency)
      Account.new(
        user: _user,
        currency: _currency,
        total: Money.new(0, _currency),
        frozen: Money.new(0, _currency)
      )
    end
  end
end
