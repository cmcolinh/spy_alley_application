# frozen string_literal: true

require 'dry-types'
require 'spy_alley_application/models/move_card'
require 'spy_alley_application/types/coercible_integer_one_to_six'

get_move_card = Hash.new{|h, k| h[k] = SpyAlleyApplication::Models::MoveCard::new(value: k)}

i = Class.new do
  def initialize(get_move_card)
    @get_move_card = get_move_card
  end

  def call(value)
    value = SpyAlleyApplication::Types::CoercibleIntegerOneToSix.call(value)
    @get_move_card[value]
  end
end.new(get_move_card)

SpyAlleyApplication::Types::MoveCard = ::Types::Constructor(Class){|value| i.call(value)}

