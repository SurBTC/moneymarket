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

    def freeze(_amount, _reason = nil)
      Assertions.valid_money _amount, currency: currency
      raise ArgumentError, 'trying to freeze more than is available' if _amount > available
      with_event(_reason) { @frozen += _amount }
    end

    def unfreeze(_amount, _reason = nil)
      Assertions.valid_money _amount, currency: currency
      raise ArgumentError, 'trying to unfreeze more than is frozen' if _amount > frozen
      with_event(_reason) { @frozen -= _amount }
    end

    def deposit(_amount, _reason = nil)
      Assertions.valid_money _amount, currency: currency
      with_event(_reason) { @total += _amount }
    end

    def spend(_amount, _reason = nil)
      Assertions.valid_money _amount, currency: currency
      raise ArgumentError, 'not enough funds to withdraw' if _amount > available
      with_event(_reason) { @total -= _amount }
    end

    def spend_frozen(_amount, _reason = nil)
      Assertions.valid_money _amount, currency: currency
      raise ArgumentError, 'trying to unfreeze more than is frozen' if _amount > frozen

      with_event(_reason) do
        @frozen -= _amount
        @total -= _amount
      end
    end

    private

    def with_event(_reason)
      event = BalanceChangedEvent.new
      event.account = self
      event.reason = _reason
      event.total_before = total
      event.frozen_before = frozen

      yield

      event.total_after = total
      event.frozen_after = frozen
      EventManager.register event
    end
  end
end
