# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class Embassy
      class French
        extend Dry::Initializer
        option :embassy, default: ->{SpyAlleyApplication::Results::Embassy::new}
        def call(player_model:, opponent_models:, change_orders:, action_hash: nil, decks_model: nil)
          embassy.(
            player_model: player_model,
            opponent_models: opponent_models,
            change_orders: change_orders,
            nationality: 'french'
          )
        end
      end
    end
  end
end

