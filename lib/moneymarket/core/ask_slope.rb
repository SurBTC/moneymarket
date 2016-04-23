module Moneymarket
  class AskSlope < BidSlope
    private

    def compare_limit(_a, _b)
      _a <=> _b
    end
  end
end
