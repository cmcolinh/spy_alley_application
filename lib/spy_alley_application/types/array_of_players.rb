# frozen_string_literal: true

require 'spy_alley_application/models/player'

SpyAlleyApplication::Types::ArrayOfPlayers =
  Types::Array::of(SpyAlleyApplication::Models::Player)
