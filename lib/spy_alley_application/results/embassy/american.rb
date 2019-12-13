# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class Embassy
      class American
        extend Dry::Initializer
        option :embassy, default: ->{SpyAlleyApplication::Results::Embassy::new}
        def call(player_model:, opponent_models:, change_orders:, action_hash:, decks_model: nil)
          embassy.(
            player_model: player_model,
            opponent_models: opponent_models,
            change_orders: change_orders,
            action_hash: action_hash,
            nationality: 'american'
          )
        end
      end
    end
  end
end
