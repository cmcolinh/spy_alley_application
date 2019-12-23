# frozen_string_literal: true

module SpyAlleyApplication
  module Actions
    class ChooseIdentityAction
      extend Dry::Initializer
      option :next_player_options, default: -> do
        SpyAlleyApplication::Results::NextPlayerUp::NextPlayerOptions::new
      end
      def call(player_model:, change_orders:, action_hash:, opponent_models:, decks_model: nil)
        identity_chosen   = action_hash[:nationality]
        next_player_up    = action_hash[:next_player_up]
        remaining_choices = action_hash[:remaining_choices]
        change_orders.choose_new_spy_identity_action(
          player: {game: player_model.game, seat: player_model.seat},
          identity_chosen: identity_chosen
        )
        change_orders = change_orders.add_next_player_up(seat: next_player_up)
        if remaining_choices&.size&.> 0
          change_orders = change_orders.add_spy_eliminator_option(options: remaining_choices)
        else
          all_models = opponent_models + [player_model]
          next_player_options.(
            next_player_model: all_models.select{|p| p.seat.eql? next_player_up}.first,
            opponent_models: all_models.reject{|p| p.seat.eql? next_player_up},
            action_hash: action_hash,
            change_orders: change_orders
          )
        end
      end
    end
  end
end
