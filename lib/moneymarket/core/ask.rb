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
      volume || amount
    end

    def destination_collected_amount(for_volume: nil)
      Calculator.quote(volume: volume || amount, unit_price: limit)
    end

    def volume_required_to_collect(_source_amount)
      _source_amount
    end
  end
end
