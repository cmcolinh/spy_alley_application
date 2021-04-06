# frozen string literal: true

require 'change_orders'
require 'dry-auto_inject'
require 'dry-container'
require 'spy_alley_application/actions/generate_new_game'
require 'spy_alley_application/results/nodes/make_accusation_option_node'
require 'spy_alley_application/results/nodes/next_player_node'
require 'spy_alley_application/results/nodes/result_game_board_node'
require 'spy_alley_application/results/nodes/roll_die_option_node'
require 'spy_alley_application/results/nodes/use_move_card_option_node'
require 'spy_alley_application/results/process_start_of_turn_options'

module SpyAlleyApplication
  class DependencyContainer
    extend Dry::Container::Mixin
    register :change_orders_initializer do
      new_change_orders = ChangeOrders::Container::new
      ->{new_change_orders}
    end

    namespace :actions do
      register :generate_new_game do
        get_result_game_board_node =
          SpyAlleyApplication::DependencyContainer.resolve('results.get_result_game_board_node')
        process_start_of_turn_options =
          SpyAlleyApplication::DependencyContainer.resolve('results.process_start_of_turn_options')
        SpyAlleyApplication::Actions::GenerateNewGame::new(
          get_result_game_board_node: get_result_game_board_node,
          process_start_of_turn_options: process_start_of_turn_options)
      end
    end

    namespace :results do
      register :get_make_accusation_option_node do
        ->(player_id_list:) do
          SpyAlleyApplication::Results::Nodes::MakeAccusationOptionNode::new(
            player_id_list: player_id_list)
        end
      end

      register :get_next_player_node do
        ->(player_id:) do
          SpyAlleyApplication::Results::Nodes::NextPlayerNode::new(player_id: player_id)
        end
      end

      register :get_result_game_board_node do
        ->(game_board:) do
          SpyAlleyApplication::Results::Nodes::ResultGameBoardNode::new(game_board: game_board)
        end
      end

      register :get_roll_die_option_node do
        roll_die = SpyAlleyApplication::Results::Nodes::RollDieOptionNode::new
        ->{roll_die}
      end

      register :get_use_move_card_option_node do
        ->(card_list:) do
          SpyAlleyApplication::Results::Nodes::UseMoveCardOptionNode::new(card_list: card_list)
        end
      end

      register :process_start_of_turn_options do
        SpyAlleyApplication::Results::ProcessStartOfTurnOptions::new(
          get_roll_die_option_node: resolve(:get_roll_die_option_node),
          get_use_move_card_option_node: resolve(:get_use_move_card_option_node),
          get_make_accusation_option_node: resolve(:get_make_accusation_option_node),
          get_next_player_node: resolve(:get_next_player_node)).method(:call)
      end
    end
  end
end

