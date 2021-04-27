# frozen string literal: true

require 'dry-initializer'

module SpyAlleyApplication
  module Validator
    class ConfiscateMaterials
      include Dry::Initializer.define -> do
        option :validate_target_player_id, type: ::Types::Callable
        option :full_validator_for, type: ::Types::Hash
      end

      def call(action_hash)
        result = validate_target_player_id.(action_hash)
        return result if result.failure?
        validate = full_validator_for[result[:target_player_id]]
        validate.(action_hash)
      end
    end
  end
end

