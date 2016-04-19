module Moneymarket
  class Account
    attr_reader :user, :currency, :total, :frozen, :ref

    def initialize(_user, _currency, _total, _frozen, _ref = nil)
      @user = _user
      @currency = _currency
      @total = _total
      @frozen = _frozen
      @ref = _ref
    end

    def available
      total - frozen
    end

    def freeze(_amount)
      # TODO: check currency?
      raise ArgumentError, 'amount to freeze must be positive' if _amount < 0
      raise ArgumentError, 'trying to freeze more than is available' if _amount > available
      @frozen += _amount
    end

    def unfreeze(_amount)
      raise ArgumentError, 'amount to unfreeze must be positive' if _amount < 0
      raise ArgumentError, 'trying to unfreeze more than is frozen' if _amount > frozen
      @frozen -= _amount
    end

    def deposit(_amount)
      raise ArgumentError, 'amount to deposit must be positive' if _amount < 0
      @total += _amount
    end

    def withdraw(_amount)
      raise ArgumentError, 'amount to withdraw must be positive' if _amount < 0
      raise ArgumentError, 'not enough funds to withdraw' if _amount > available
      @total -= _amount
    end
  end
end
