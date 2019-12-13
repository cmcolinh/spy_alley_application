# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class NextPlayerUp
      class NextPlayerOptions
        def call(next_player_model:, opponent_models:, change_orders:, action_hash:)
          opponent_seats = opponent_models.map(&:seat).sort.map{|seat| "seat_#{seat}"}
          nationalities = %w(french german spanish italian american russian)
          options = {
            accept_roll: true,
            accept_make_accusation: {player: opponent_seats, nationality: nationalities}
          }
          if !next_player_model.move_cards.select{|k, v| v > 0}.empty?
            options[:accept_use_move_card] = #player_move_cards have {1=>0, 2=>1... 6=>0} 
              next_player_model.move_cards.select{|k, v| v > 0}.keys.sort.uniq
          end
          change_orders.add_top_level_options(options)
        end
      end
    end
  end
end
