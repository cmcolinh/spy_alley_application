# frozen_string_literal: true

require 'spy_alley_application/results/no_action_result'
require 'spy_alley_application/results/buy_equipment'
require 'spy_alley_application/results/draw_move_card'

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
      end
    end
  end
end
