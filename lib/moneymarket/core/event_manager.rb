module Moneymarket
  class EventManager
    def self.current_manager
      @current_manager
    end

    def self.register(_event)
      current_manager.register _event if current_manager
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