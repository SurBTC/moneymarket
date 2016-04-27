module Moneymarket
  class BidSlope
    include Enumerable

    def initialize
      @orders = []
    end

    def add(_order)
      idx = @orders.index { |o| compare(o, _order) > 0 }
      if idx.nil?
        @orders << _order
      else
        @orders.insert idx, _order
      end
    end

    def remove(_order)
      @orders.delete(_order)
    end

    def each(&_block)
      @orders.each(&_block)
    end

    def count
      @orders.count
    end

    def each_until_limit(_limit, &_block)
      enum = Enumerator.new do |y|
        @orders.each do |order|
          break if compare_limit(order.limit, _limit) > 0
          y << order
        end
      end
      return enum if _block.nil?
      enum.each(&_block)
    end

    private

    def compare_limit(_a, _b)
      _b <=> _a
    end

    def compare(a, b)
      r = compare_limit(a.limit, b.limit)
      r = a.timestamp <=> b.timestamp if r == 0
      r
    end
  end
end
