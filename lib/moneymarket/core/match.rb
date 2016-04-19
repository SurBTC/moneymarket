module Moneymarket
  class Match
    attr_reader :market, :bid, :ask
    attr_accessor :volume

    def initialize(_trigger, _match, _volume)
      @trigger = _trigger
      @bid = _trigger.bid? ? _trigger : _match
      @ask = _trigger.bid? ? _match : _trigger
      @match = _match
      @volume = _volume
    end

    def price_paid
      match.limit
    end
  end
end
