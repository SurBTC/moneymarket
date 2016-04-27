module Moneymarket
  class LimitMatches < Command.new(:matches, :destination_limit)
    def perform
      remaining = destination_limit

      matches.select do |match|
        next false if remaining.cents <= 0

        quote = calc_quote(match)
        if quote > remaining
          # IDEA: instead of lowering the match amount maybe this should be considered insolvency
          match.volume = calc_volume(match, remaining)
        end

        remaining -= quote
        match.volume.cents > 0
      end
    end

    private

    def calc_quote(_match)
      _match.match.destination_collected_amount for_volume: _match.volume
    end

    def calc_volume(_match, _new_quote)
      _match.match.volume_required_to_collect _new_quote
    end
  end
end