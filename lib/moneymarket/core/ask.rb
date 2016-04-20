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
      volume || amount
    end

    def destination_collected_amount(for_volume: nil)
      Assertions.valid_money for_volume, currency: base_currency unless for_volume.nil?
      Calculator.quote(volume: volume || amount, unit_price: limit)
    end

    def volume_required_to_collect(_source_amount)
      Assertions.valid_money _source_amount, currency: base_currency
      _source_amount
    end
  end
end
