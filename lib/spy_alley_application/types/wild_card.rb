# frozen string_literal: true

require 'dry-types'
require 'spy_alley_application/models/wild_card'

wild_card_enum = Types::String.enum('wild card')
wild_card = SpyAlleyApplication::Models::WildCard::new

SpyAlleyApplication::Types::WildCard =
  Types::Constructor(SpyAlleyApplication::Models::WildCard) do |value|
    wild_card_enum.call(value)
    wild_card
  end

