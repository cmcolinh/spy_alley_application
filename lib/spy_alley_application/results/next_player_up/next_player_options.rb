# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class NextPlayerUp
      class NextPlayerOptions
        def call(next_player_model:, opponent_models:, change_orders:)
          opponent_seats = opponent_models.map(&:seat).sort.map{|seat| "seat_#{seat}"}
          nationalities %w(french german spanish italian american russian)
          options = {
            accept_roll: true,
            accept_make_accusation: {player: opponent_seats, nationality: nationalities}
          }
          if !next_player_model.move_cards.empty?
            options[:accept_use_move_card] = next_player_model.move_cards.sort.uniq
          end
          change_orders.add_top_level_options(options)
        end
      end
    end
  end
end
