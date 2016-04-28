module Moneymarket
  class Event
    def childs
      @childs ||= []
    end

    def register(_event)
      childs << _event
    end
  end
end