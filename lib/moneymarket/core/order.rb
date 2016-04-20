module Moneymarket
  class Order
    include AASM

    aasm whiny_transitions: false do
      state :new, :initial => true
      state :open, :traded, :canceled

      event :prepare do
        transitions from: :new, to: :traded, guard: :consumed?
        transitions from: :new, to: :open, guard: :limit_order?
        transitions from: :new, to: :traded, guard: :market_order?
      end

      event :consume, before: :decrement_volume do
        transitions from: [:new, :open], to: :traded, guard: :consumed?
      end

      event :cancel do
        transitions from: :open, to: :canceled
      end
    end

    attr_reader :user, :ts, :volume, :limit, :fee, :ref

    def initialize(state: nil, ts: nil, volume: nil, limit: nil, fee: 0.0, user: nil, ref: nil)
      Assertions.valid_money volume
      Assertions.valid_money limit unless limit.nil?
      Assertions.valid_fee fee

      aasm.current_state = state unless state.nil?
      @user = user
      @ts = ts
      @volume = volume
      @limit = limit
      @fee = fee
      @ref = ref
    end

    def limit_order?
      !limit.nil?
    end

    def market_order?
      limit.nil?
    end

    def consumed?
      volume.cents == 0
    end

    def belongs_to?(_market)
      return false if base_currency != market.base_currency
      return true if market_order?
      return false if quote_currency != market.quote_currency
      return true
    end

    def base_currency
      volume.currency
    end

    def quote_currency
      limit.currency
    end

    def closed?
      traded? || canceled?
    end

    private

    def decrement_volume(_volume)
      Assertions.valid_money _volume, currency: base_currency
      raise ArgumentError, 'cannot consume, order closed' if closed?
      raise ArgumentError, 'trying to consume more than is available' if _volume > @volume

      @volume -= _volume
    end
  end
end
