# frozen string literal: true

require 'spy_alley_application/models/game_state/start_of_turn'
require 'spy_alley_application/models/game_state/move_option'
require 'spy_alley_application/models/game_state/spy_eliminator'
require 'spy_alley_application/models/game_state/choose_new_spy_identity'

SpyAlleyApplication::Types::GameState =
  SpyAlleyApplication::Models::GameState::ChooseNewSpyIdentity |
  SpyAlleyApplication::Models::GameState::SpyEliminator |
  SpyAlleyApplication::Models::GameState::MoveOption |
  SpyAlleyApplication::Models::GameState::StartOfTurn

