class MatchOrderToSlope < Command.new(:slope, :order)
  def perform
    Enumerator.new do |y|
      remaining = order.volume
      each_order do |match|
        next if match.timestamp > _order.timestamp # << this should trigger an alert, should never happen

        if match.volume >= remaining
          y << build_match(match, remaining)
          break
        else
          y << build_match(match, match.volume)
          remaining -= match.volume
        end
      end
    end
  end

  private

  def each_order
    if order.market_order?
      slope.each
    else
      slope.each_until_limit(order.limit)
    end
  end

  def build_match(_match, _volume)
    Match.new(trigger: order, match: _match, volume: _volume)
  end
end
