require 'money'
require 'aasm'
require 'moneymarket/version'

require 'moneymarket/utils/assertions'
require 'moneymarket/utils/calculator'
require 'moneymarket/utils/command'

require 'moneymarket/core/event'
require 'moneymarket/core/event_manager'
require 'moneymarket/core/order'
require 'moneymarket/core/bid'
require 'moneymarket/core/ask'
require 'moneymarket/core/market'
require 'moneymarket/core/match'
require 'moneymarket/core/account'
require 'moneymarket/core/account_manager'
require 'moneymarket/core/bid_slope'
require 'moneymarket/core/ask_slope'
require 'moneymarket/core/book'

require 'moneymarket/events/balance_changed_event'

module Moneymarket
  def self.book()
  end
end
