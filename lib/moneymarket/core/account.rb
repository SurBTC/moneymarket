module Moneymarket
  class Account
    attr_reader :user, :currency, :total, :frozen, :ref

    def initialize(user: nil, currency: nil, total: nil, frozen: nil, ref: nil)
      Assertions.valid_money total, currency: currency
      Assertions.valid_money frozen, currency: currency

      @user = user
      @currency = currency
      @total = total
      @frozen = frozen
      @ref = ref
    end

    def available
      total - frozen
    end

    def freeze(_amount)
      Assertions.valid_money _amount, currency: currency
      raise ArgumentError, 'trying to freeze more than is available' if _amount > available
      @frozen += _amount
    end

    def unfreeze(_amount)
      Assertions.valid_money _amount, currency: currency
      raise ArgumentError, 'trying to unfreeze more than is frozen' if _amount > frozen
      @frozen -= _amount
    end

    def deposit(_amount)
      Assertions.valid_money _amount, currency: currency
      @total += _amount
    end

    def withdraw(_amount)
      Assertions.valid_money _amount, currency: currency
      raise ArgumentError, 'not enough funds to withdraw' if _amount > available
      @total -= _amount
    end
  end
end
