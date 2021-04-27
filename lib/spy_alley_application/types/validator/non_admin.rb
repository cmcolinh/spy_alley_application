# frozen_string_literal: true

require 'spy_alley_application/types/validator/buy_equipment'
require 'spy_alley_application/types/validator/choose_new_spy_identity'
require 'spy_alley_application/types/validator/confiscate_materials'
require 'spy_alley_application/types/validator/make_accusation'
require 'spy_alley_application/types/validator/move'
require 'spy_alley-application/types/validator/pass'
require 'spy_alley_application/types/validator/roll_die'
require 'spy_alley_application/types/validator/use_move_card'

SpyAlleyApplication::Types::Validator::NonAdmin =
  SpyAlleyApplication::Types::Validator::BuyEquipment |
  SpyAlleyApplication::Types::Validator::ChooseNewSpyIdentity |
  SpyAlleyApplicaiton::Types::Validator::ConfiscateMaterials |
  SpyAlleyApplication::Types::Validator::MakeAccusation |
  SpyAlleyApplication::Types::Validator::Move |
  SpyAlleyApplication::Types::Validator::Pass |
  SpyAlleyApplication::Types::Validator::RollDie |
  SpyalleyApplication::Types::Validator::UseMoveCard

