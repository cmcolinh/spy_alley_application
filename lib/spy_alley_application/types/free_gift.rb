# frozen string_literal: true

require 'spy_alley_application/types/equipment'
require 'spy_alley_application/models/wild_card'

cached_wild_card = SpyAlleyApplication::Models::WildCard::new

i = Class.new do
  def initialize(cached_wild_card)
    @cached_wild_card = cached_wild_card
  end

  def call(free_gift)
    result = nil
    if free_gift.to_s.eql?('wild card')
      result = @cached_wild_card
    end
    result || SpyAlleyApplication::Types::Equipment.call(free_gift)
  end
end.new(cached_wild_card)

SpyAlleyApplication::Types::FreeGift = Types::Constructor(Class){|value| i.call(value)}
