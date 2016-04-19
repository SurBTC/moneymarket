module Moneymarket
  class Order
    NEW = :new
    OPEN = :open
    TRADED = :traded
    CANCELED = :canceled

    attr_reader :user, :volume, :limit, :fee, :ref

    def initialize(user: nil, status: NEW, volume: nil, limit: nil, fee: 0.0, ref: nil)
      @user = user
      @status = status
      @volume = volume
      @limit = limit
      @fee = fee
      @ref = ref
    end

    def market_order?
      limit.nil?
    end

    def base_currency
      volume.currency
    end

    def quote_currency
      limit.currency
    end

    def consume(_volume)
      raise ArgumentError, 'cannot consume, order closed' if closed?
      raise ArgumentError, 'amount to consume must be positive' if _volume < 0
      raise ArgumentError, 'trying to consume more than is available' if _volume > @volume
      @volume -= _volume

      @status = TRADED if @volume == 0
    end

    def flag_as_open
      if market_order?
        flag_as_canceled
      else
        @status = OPEN if new?
      end
    end

    def flag_as_canceled
      @status = CANCELED unless closed?
    end

    [NEW, OPEN, TRADED, CANCELED].each do |name|
      define_method("#{name}?") { @status == name }
    end

    def closed?
      traded? || canceled?
    end
  end
end
