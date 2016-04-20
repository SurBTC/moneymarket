module Moneymarket
  class Bid < Order
    def bid?
      true
    end

    def source_account
      :quote_account
    end

    def destination_account
      :base_account
    end

    def source_required_amount(for_volume: nil)
      Assertions.valid_money for_volume, currency: base_currency unless for_volume.nil?
      Calculator.quote(volume: for_volume || volume, unit_price: limit)
    end

    def destination_collected_amount(for_volume: nil)
      Assertions.valid_money for_volume, currency: base_currency unless for_volume.nil?
      for_volume || volume
    end

    def volume_required_to_collect(_source_amount)
      Assertions.valid_money _source_amount, currency: quote_currency
      Calculator.volume(
        quote: _source_amount,
        unit_price: limit,
        unit_currency: volume.currency
      )
    end
  end
end
