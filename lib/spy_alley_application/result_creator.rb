# frozen_string_literal: true

require 'spy_alley_application/results/no_action_result'
require 'spy_alley_application/results/buy_equipment'
require 'spy_alley_application/results/draw_move_card'
require 'spy_alley_application/results/take_another_turn'
require 'spy_alley_application/results/draw_free_gift'
require 'spy_alley_application/results/sold_top_secret_information'
require 'spy_alley_application/results/border_crossing'
require 'spy_alley_application/results/move_back_two_spaces'
require 'spy_alley_application/results/spy_eliminator'
require 'spy_alley_application/results/embassy'
require 'spy_alley_application/results/confiscate_materials'

module SpyAlleyApplication
  class ResultCreator
    def call(space_to_move:)
      case space_to_move
      when '0', '14'
        SpyAlleyApplication::Results::NoActionResult::new
      when '1'
        SpyAlleyApplication::Results::BuyEquipment::RussianPassword::new
      when '2', '5', '12', '19', '22'
        SpyAlleyApplication::Results::DrawMoveCard::new
      when '3'
        SpyAlleyApplication::Results::BuyEquipment::Disguises::new
      when '4'
        SpyAlleyApplication::Results::BuyEquipment::AmericanPassword::new
      when '6'
        SpyAlleyApplication::Results::TakeAnotherTurn::new
      when '7', '20'
        SpyAlleyApplication::Results::DrawFreeGift::new
      when '8'
        SpyAlleyApplication::Results::SoldTopSecretInformation::Ten::new
      when '9'
        SpyAlleyApplication::Results::BuyEquipment::ItalianPassword::new
      when '10'
        SpyAlleyApplication::Results::BuyEquipment::Keys::new
      when '11'
        SpyAlleyApplication::Results::BuyEquipment::SpanishPassword::new
      when '13', '23'
        SpyAlleyApplication::Results::BuyEquipment::BlackMarket::new
      when '15'
        SpyAlleyApplication::Results::BorderCrossing::new
      when '16'
        SpyAlleyApplication::Results::MoveBackTwoSpaces::new
      when '17'
        SpyAlleyApplication::Results::BuyEquipment::GermanPassword::new
      when '18'
        SpyAlleyApplication::Results::BuyEquipment::Codebooks::new
      when '21'
        SpyAlleyApplication::Results::BuyEquipment::FrenchPassword::new
      when '1s'
        SpyAlleyApplication::Results::SoldTopSecretInformation::Twenty::new
      when '2s'
        SpyAlleyApplication::Results::SpyEliminator::new
      when '3s'
        SpyAlleyApplication::Results::Embassy::French::new
      when '4s'
        SpyAlleyApplication::Results::Embassy::German::new
      when '5s'
        SpyAlleyApplication::Results::ConfiscateMaterials::new
      when '6s'
        SpyAlleyApplication::Results::Embassy::Spanish::new
      when '7s'
        SpyAlleyApplication::Results::Embassy::Italian::new
      when '8s'
        SpyAlleyApplication::Results::Embassy::American::new
      when '9s'
        SpyAlleyApplication::Results::Embassy::Russian::new
      end
    end
  end
end
