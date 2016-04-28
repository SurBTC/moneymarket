module Moneymarket
  module Calculator
    extend self

    def quote(volume: nil, unit_price: nil)
      base_currency = volume.currency
      quote = ((unit_price.cents * volume.cents).to_d / base_currency.subunit_to_unit).ceil
      Money.new quote, unit_price.currency
    end

    def volume(quote: nil, unit_price: nil, unit_currency: nil)
      volume = ((quote.cents * unit_currency.subunit_to_unit).to_d / unit_price.cents).floor
      Money.new volume, unit_currency
    end

    def fee(amount: nil, percent: nil)
      result = (amount.cents * percent).floor # fees always round to floor
      Money.new result, amount.currency
    end

    def order_fee(order: nil, collected_amount: nil) # move this to command
      collected_amount = order.collected_amount if collected_amount.nil?
      fee_cents = (collected_amount.cents * order.fee).floor
      Money.new fee_cents, collected_amount.currency
    end
  end
end