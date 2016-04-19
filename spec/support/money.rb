Money::Currency.register(
  priority:            1,
  iso_code:            "BTC",
  name:                "Bitcoin",
  symbol:              "฿",
  symbol_first:        true,
  subunit:             "Satoshi",
  subunit_to_unit:     100_000_000,
  thousands_separator: ",",
  decimal_mark:        "."
)

Money::Currency.register(
  priority:               100,
  iso_code:               "CLP",
  name:                   "Chilean Peso",
  symbol:                 "$",
  disambiguate_symbol:    "CLP",
  alternate_symbols:      [],
  subunit:                "Peso",
  subunit_to_unit:        100,
  symbol_first:           true,
  html_entity:            "&#36;",
  decimal_mark:           ",",
  thousands_separator:    ".",
  iso_numeric:            "152",
  smallest_denomination:  1
)

module Helpers
  [:BTC, :CLP, :USD].each do |currency|
    define_method(currency.to_s.downcase) do |value = nil|
      return Money.from_amount value, currency if value
      Money::Currency.new currency
    end
  end
end