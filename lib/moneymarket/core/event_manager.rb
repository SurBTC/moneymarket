module Moneymarket
  class EventManager
    def self.current_manager
      @current_manager
    end

    def self.register(_event, &_block)
      current_manager.register _event if current_manager

      if _block
        begin
          actual_manager = @current_manager
          @current_manager = _event
          _block.call
        ensure
          @current_manager = actual_manager
        end
      end
    end

    def initialize
      @events = []
    end

    def register(_event)
      @events << _event
    end

    def flush
      events = @events
      @events = []
      events
    end

    def capture
      lock_manager
      begin
        yield
      ensure
        release_manager
      end
    end

    private

    def self.current_manager=(_manager)
      @current_manager = _manager
    end

    def lock_manager
      raise 'manager already locked' unless self.class.current_manager.nil?
      self.class.current_manager = self
    end

    def release_manager
      self.class.current_manager = nil
    end
  end
end