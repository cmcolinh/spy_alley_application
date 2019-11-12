# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class Embassy
      class Italian
        extend Dry::Initializer
        option :embassy, default: ->{SpyAlleyApplication::Results::Embassy::new}
        def call(player_model:, change_orders:, action_hash: nil, target_player_model: nil, decks_model: nil)
          embassy.(player_model: player_model, nationality: 'italian')
        end
      end
    end
  end
end
