module Moneymarket
  def Book
    attr_reader :asks, :bids

    def initialize(_market)
      @market = _market
      @bids = Slope.new { |a, b| a.limit_cents <=> b.limit_cents }
      @asks = Slope.new { |a, b| b.limit_cents <=> a.limit_cents }
    end

    def flush_events
      flushed = @events
      @events = []
      flushed
    end

    def push(_order)
      # TODO: check market(currency)

      if _order.new?
        raise ArgumentError, 'insolvent order' unless check_solvent _order

        matches = match_to_slope _order
        matches = adjust_market_order matches, _order if _order.market_order?
        preload_balances matches
        matches.each { |tx| execute_match tx }
        _order.flag_as_open

        freeze_source_balance _order
        # TODO: execute_triggers (stop-loss, take-profit, etc)
      end

      slope_for(_order).add _order if _order.open?
    end

    def cancel(_order)
      if _order.open?

        slope_for(_order).remove _order
      end
    end

    private

    def slope_for(_order)
      if order.bid? then bids else asks end
    end

    def oposite_slope(_order)
      if order.bid? then asks else bids end
    end

    def check_solvent(_order)
      CheckOrderSolvent.for market: market, order: _order
    end

    def match_to_slope(_order)
      slope = oposite_slope(_order)
      MatchOrderToSlope.for slope: slope, order: _order
    end

    def adjust_market_order(_matches, _order)
      limit = market.source_account(_order).available_amount
      LimitMatches.for matches: _matches, limit: limit
    end

    def execute_match(_match)
      @events << ExecuteMatch.for(market: market, match: _match)
    end

    def preload_balances(_matches)
      users = _matches.map { |m| [m.bid.user, m.ask.user] }.flatten.uniq
      market.preload_user_balances users
    end
  end
end
