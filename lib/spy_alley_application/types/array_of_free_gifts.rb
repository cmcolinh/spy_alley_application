# frozen_string_literal: true

require 'spy_alley_application/types/free_gift'

SpyAlleyApplication::Types::ArrayOfFreeGifts =
  Types::Array::of(SpyAlleyApplication::Types::FreeGift)

