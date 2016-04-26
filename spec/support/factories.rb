module Helpers
  def create_order(_volume, _limit = nil, _options = {}, _type = Moneymarket::Order)
    if _limit.is_a? Hash
      _options = _limit
      _limit = nil
    end

    _options[:volume] = _volume
    _options[:limit] = _limit

    _type.new _options
  end

  def create_bid(_volume, _limit = nil, _options = {})
    create_order _volume, _limit, _options, Moneymarket::Bid
  end

  def create_ask(_volume, _limit = nil, _options = {})
    create_order _volume, _limit, _options, Moneymarket::Ask
  end

  def create_domain(_base, _quote, _fee = 'exchange')
    Moneymarket::Domain.new(Moneymarket::AccountManager.new, _base, _quote, _fee)
  end
end