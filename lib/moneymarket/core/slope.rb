module Moneymarket
  class Slope
    def initialize(&_comp_func)
      @orders = []
      @cmp = _comp_func
    end

    def add(_order)
      idx = orders.index { |o| compare(o, _order) > 0 }
      if idx.nil?
        orders << _order
      else
        orders.insert idx, _order
      end
    end

    def remove(_order)
      orders.delete(_order)
    end

    def each
      orders.each
    end

    def each_until_limit(_limit)
      Enumerator.new do |y|
        orders.each do |order|
          break if cmp.call(order, _limit) > 0
          y << order
        end
      end
    end

    private

    attr_reader :orders, :cmp

    def compare(a, b)
      r = cmp.call a, b
      r = a.created_at <=> b.created_at if r == 0
      r
    end
  end
end
