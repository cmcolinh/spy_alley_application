# frozen_string_literal: true

require 'spy_alley_application/results/embassy/french'
require 'spy_alley_application/results/embassy/german'
require 'spy_alley_application/results/embassy/spanish'
require 'spy_alley_application/results/embassy/italian'
require 'spy_alley_application/results/embassy/american'
require 'spy_alley_application/results/embassy/russian'

module SpyAlleyApplication
  module Results
    class Embassy
      def call(player_model:, change_orders:, nationality:)
        puts "nationality:  #{nationality}"
        puts "spy_identity: #{player_model.spy_identity}"
        if player_model.spy_identity.eql?(nationality) && all_equipment_collected(player_model, nationality)
          change_orders.add_game_victory(
            player: {game: player_model.game, seat: player_model.seat},
            reason: 'reached their embassy with a full set of equipment'
          )
          true
        else
          false
        end
      end

      private
      def all_equipment_collected(player_model, nationality)
        (player_model.equipment.filter{|e| e.include? nationality}.count + player_model.wild_cards) >= 4
      end
    end
  end
end
