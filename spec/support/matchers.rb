RSpec::Matchers.define :register_event do |type, definition = {}|
  match do |actual|
    manager = Moneymarket::EventManager.new
    manager.capture { actual.call }
    events = manager.flush
    events.any? do |event|
      next false unless event.is_a? type
      definition.each.all? { |k, v| event.send(k) == v }
    end
  end

  def supports_block_expectations?
    true # or some logic
  end
end