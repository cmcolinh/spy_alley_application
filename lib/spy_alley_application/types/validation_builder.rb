# frozen string_literal: true

require 'spy_alley_application/models/validator/buying_equipment'
require 'spy_alley_application/models/validator/choosing_new_spy_identity'
require 'spy_alley_application/models/validator/confiscating_materials'
require 'spy_alley_application/models/validator/making_accusation'
require 'spy_alley_application/models/validator/moving'
require 'spy_alley_application/models/validator/passing'
require 'spy_alley_application/models/validator/rolling_die'
require 'spy_alley_application/models/validator/using_move_card'

SpyAlleyApplication::Types::ValidationBuilder =
  SpyAlleyApplication::Models::Validator::BuyingEquipment |
  SpyAlleyApplication::Models::Validator::ChoosingNewSpyIdentity |
  SpyAlleyApplication::Models::Validator::ConfiscatingMaterials |
  SpyAlleyApplication::Models::Validator::MakingAccusation |
  SpyAlleyApplication::Models::Validator::Moving |
  SpyAlleyApplication::Models::Validator::Passing |
  SpyAlleyApplication::Models::Validator::RollingDie |
  SpyAlleyApplication::Models::Validator::UsingMoveCard

