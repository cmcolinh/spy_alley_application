# frozen string literal: true

require 'spy_alley_application/models/game_state/buy_equipment'
require 'spy_alley_application/models/game_state/choose_new_spy_identity'
require 'spy_alley_application/models/game_state/confiscate_materials'
require 'spy_alley-application/models/game_state/game_over'
require 'spy_alley_application/models/game_state/move_option'
require 'spy_alley_application/models/game_state/spy_eliminator'
require 'spy_alley_application/models/game_state/start_of_turn'

SpyAlleyApplication::Types::GameState =
  SpyAlleyApplication::Models::GameState::BuyEquipment |
  SpyAlleyApplication::Models::GameState::ChooseNewSpyIdentity |
  SpyAlleyApplication::Models::GameState::ConfiscateMaterials |
  SpyAlleyApplication::Models::GameState::GameOver |
  SpyAlleyApplication::Models::GameState::MoveOption |
  SpyAlleyApplication::Models::GameState::SpyEliminator |
  SpyAlleyApplication::Models::GameState::StartOfTurn

