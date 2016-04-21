module Moneymarket
  class Ask < Order
    def bid?
      false
    end

    def source_account
      :base_account
    end

    def destination_account
      :quote_account
    end

    def source_required_amount(for_volume: nil)
      Assertions.valid_money for_volume, currency: base_currency unless for_volume.nil?
      for_volume || volume
    end

    def destination_collected_amount(for_volume: nil)
      Assertions.valid_money for_volume, currency: base_currency unless for_volume.nil?
      Calculator.quote(volume: for_volume || volume, unit_price: limit)
    end

    def volume_required_to_collect(_destination_amount)
      Assertions.valid_money _destination_amount, currency: quote_currency
      Calculator.volume(
        quote: _destination_amount,
        unit_price: limit,
        unit_currency: volume.currency
      )
    end
  end
end
