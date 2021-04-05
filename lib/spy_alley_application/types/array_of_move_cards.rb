# frozen_string_literal: true

require 'spy_alley_application/types/move_card'

SpyAlleyApplication::Types::ArrayOfMoveCards =
  ::Types::Array::of(SpyAlleyApplication::Types::MoveCard)
