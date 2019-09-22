# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/actions/move_distance_action/roll_action'
require 'spy_alley_application/actions/move_distance_action/admin_roll_action'
require 'spy_alley_application/actions/move_distance_action/move_card_action'

module SpyAlleyApplication
  module Actions
    class MoveDistanceAction
      extend Dry::Initializer
      option :move_action
    end
  end
end
