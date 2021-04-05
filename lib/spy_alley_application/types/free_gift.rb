# frozen string_literal: true

require 'spy_alley_application/types/equipment'
require 'spy_alley_application/models/wild_card'

cached_free_gift = SpyAlleyApplication::Models::WildCard::new

i = Class.new do
  def initialize(cached_free_gift)
    @cached_free_gift = cached_free_gift
  end

  def call(free_gift)
    result = nil
    if free_gift.eql?('wild card')
      result = @cached_free_gift
    end
    result || SpyAlleyApplication::Types::Equipment.call(free_gift)
  end
end.new(cached_free_gift)

SpyAlleyApplication::Types::FreeGift = Types::Constructor(Class){|value| i.call(value)}
