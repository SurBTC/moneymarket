module Helpers
  def create_order(_volume, _limit = nil, _options = {})
    if _limit.is_a? Hash
      _options = _limit
      _limit = nil
    end

    _options[:volume] = _volume
    _options[:limit] = _limit

    Moneymarket::Order.new _options
  end
end