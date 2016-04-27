module Moneymarket
  class MatchOrderToSlope < Command.new(:slope, :order)
    def perform
      Enumerator.new do |y|
        remaining = order.volume
        slope_orders.each do |other|
          next if other.timestamp > order.timestamp # << this should trigger an alert, should never happen

          if other.volume >= remaining
            y << build_match(other, remaining)
            break
          else
            y << build_match(other, other.volume)
            remaining -= other.volume
          end
        end
      end
    end

    private

    def slope_orders
      if order.market_order?
        slope.each
      else
        slope.each_until_limit(order.limit)
      end
    end

    def build_match(_match, _volume)
      Match.new(order, _match, _volume)
    end
  end
end