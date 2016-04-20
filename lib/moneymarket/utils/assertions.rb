module Moneymarket
  module Assertions
    extend self

    def valid_money(_value, currency: nil, negative: false)
      raise ArgumentError, 'invalid money value' unless _value.is_a? Money
      raise ArgumentError, 'invalid money value currency' if currency && currency != _value.currency
      raise ArgumentError, 'money value must be positive' if !negative && _value.cents < 0.0
    end

    def valid_fee(_value, negative: false)
      raise ArgumentError, 'invalid fee value' unless _value.is_a? Float
      raise ArgumentError, 'fee value must be less or equal to one' if _value > 1.0
      raise ArgumentError, 'fee value must be positive' if !negative && _value < 0.0
    end
  end
end