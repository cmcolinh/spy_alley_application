# frozen string literal: true

require 'change_orders'
require 'dry-auto_inject'
require 'dry-container'
require 'spy_alley_application/actions/generate_new_game'
require 'spy_alley_application/models/game_board/black_market_option_state'
require 'spy_alley_application/models/game_board/buy_equipment_option_state'
require 'spy_alley_application/models/game_board/buy_password_option_state'
require 'spy_alley_application/models/game_board/confiscate_materials_option_state'
require 'spy_alley_application/models/game_board/eliminate_player'
require 'spy_alley_application/models/game_board/embassy_victory'
require 'spy_alley_application/models/game_board/equipment_bought'
require 'spy_alley_application/models/game_board/equipment_confiscated'
require 'spy_alley_application/models/game_board/free_gift_drawn'
require 'spy_alley_application/models/game_board/money_gained_or_lost'
require 'spy_alley_application/models/game_board/move_card_drawn'
require 'spy_alley_application/models/game_board/move_options'
require 'spy_alley_application/models/game_board/new_spy_identity_chosen'
require 'spy_alley_application/models/game_board/next_game_state'
require 'spy_alley_application/models/game_board/player_moved'
require 'spy_alley_application/models/game_board/spy_eliminator_options'
require 'spy_alley_application/results/nodes/buy_equipment_option_node'
require 'spy_alley_application/results/nodes/make_accusation_option_node'
require 'spy_alley_application/results/nodes/money_gained_node'
require 'spy_alley_application/results/nodes/move_option_node'
require 'spy_alley_application/results/nodes/next_player_node'
require 'spy_alley_application/results/nodes/pass_option'
require 'spy_alley_application/results/nodes/result_game_board_node'
require 'spy_alley_application/results/nodes/roll_die_option_node'
require 'spy_alley_application/results/nodes/use_move_card_option_node'
require 'spy_alley_application/results/process_buy_equipment_options'
require 'spy_alley_application/results/process_move_options'
require 'spy_alley_application/results/process_next_turn_options'
require 'spy_alley_application/results/process_passing_spaces'

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
          SpyAlleyApplication::DependencyContainer.resolve('results.get.result_game_board_node')
        process_start_of_turn_options =
          SpyAlleyApplication::DependencyContainer.resolve('results.process_start_of_turn_options')
        SpyAlleyApplication::Actions::GenerateNewGame::new(
          get_result_game_board_node: get_result_game_board_node,
          process_start_of_turn_options: process_start_of_turn_options)
      end
    end

    namespace :game_board_effects do
      register :black_market_option_state do
        SpyAlleyApplication::Models::GameBoard::BlackMarketOptionState::new(
          next_game_state: resolve(:next_game_state)).method(:call)
      end

      register :buy_equipment_option_state do
        SpyAlleyApplication::Models::GameBoard::BuyEquipmentOptionState::new(
          next_game_state: resolve(:next_game_state)).method(:call)
      end

      register :buy_password_option_state do
        SpyAlleyApplication::Models::GameBoard::BuyPasswordOptionState::new(
          next_game_state: resolve(:next_game_state)).method(:call)
      end

      register :confiscate_materials_option_state do
        SpyAlleyApplication::Models::GameBoard::ConfiscateMaterialsOptionState::new.method(:call)
      end

      register :eliminate_player do
        SpyAlleyApplication::Models::GameBoard::EliminatePlayer::new.method(:call)
      end

      register :equipment_bought do
        SpyAlleyApplication::Models::GameBoard::EquipmentBought::new(
          next_game_state: resolve(:next_game_state)).method(:call)
      end

      register :embassy_victory do
        SpyAlleyApplication::Models::GameBoard::EmbassyVictory::new.method(:call)
      end

      register :equipment_confiscated do
        SpyAlleyApplication::Models::GameBoard::EquipmentConfiscated::new(
          next_game_state: resolve(:next_game_state)).method(:call)
      end

      register :free_gift_drawn do
        SpyAlleyApplication::Models::GameBoard::FreeGiftDrawn::new(
          next_game_state: resolve(:next_game_state)).method(:call)
      end

      register :money_gained_or_lost do
        SpyAlleyApplication::Models::GameBoard::MoneyGainedOrLost::new.method(:call)
      end

      register :move_card_drawn do
        SpyAlleyApplication::Models::GameBoard::MoveCardDrawn::new(
          next_game_state: resolve(:next_game_state)).method(:call)
      end

      register :move_options do
        SpyAlleyApplication::Models::GameBoard::MoveOptions::new.method(:call)
      end

      register :new_spy_identity_chosen do
        SpyAlleyApplication::Models::GameBoard::NewSpyIdentityChosen::new(
          next_game_state: resolve(:next_game_state)).method(:call)
      end

      register :next_game_state do
        SpyAlleyApplication::Models::GameBoard::NextGameState::new.method(:call)
      end

      register :player_moved do
        SpyAlleyApplication::Models::GameBoard::PlayerMoved::new.method(:call)
      end

      register :spy_eliminator_options do
        SpyAlleyApplication::Models::GameBoard::SpyEliminatorOptions::new(
          next_game_state: resolve(:next_game_state)).method(:call)
      end
    end

    namespace :results do
      namespace :get do
        register :buy_equipment_option_node do
          ->(options:, :limit) do
            SpyAlleyApplication::Results::Nodes::MakeAccusationOptionNode::new(
              options: options,
              limit: limit)
          end
        end

        register :make_accusation_option_node do
          ->(player_id_list:) do
            SpyAlleyApplication::Results::Nodes::MakeAccusationOptionNode::new(
              player_id_list: player_id_list)
          end
        end

        register :money_gained_node do
          ->(player_id:, amount_gained:) do
            SpyAlleyApplication::Results::Nodes::MoneyGainedNode::new(
              player_id: player_id,
              money_gained: money_gained)
          end
        end

        register :move_option_node do
          ->(options:) do
            SpyAlleyApplication::Results::Nodes::MoveOptionNode::new(
              options: options)
          end
        end

        register :next_player_node do
          ->(player_id:) do
            SpyAlleyApplication::Results::Nodes::NextPlayerNode::new(player_id: player_id)
          end
        end

        register :pass_option_node do
          pass_option_node = SpyAlleyApplication::Results::Nodes::PassOptionNode::new
          ->(options:, limit:) do
            pass_option_node
          end
        end

        register :player_movement_node do
          ->(player_id:, space_id:) do
            SpyAlleyApplication::Results::Nodes::ResultGameBoardNode::new(
              player_id: player_id,
              space_id: space_id)
          end
        end

        register :result_game_board_node do
          ->(game_board:) do
            SpyAlleyApplication::Results::Nodes::ResultGameBoardNode::new(game_board: game_board)
          end
        end

        register :roll_die_option_node do
          roll_die = SpyAlleyApplication::Results::Nodes::RollDieOptionNode::new
          ->{roll_die}
        end

        register :use_move_card_option_node do
          ->(card_list:) do
            SpyAlleyApplication::Results::Nodes::UseMoveCardOptionNode::new(card_list: card_list)
          end
        end
      end

      register :process_buy_equipment_options do
        SpyAlleyApplication::Results::ProcessBuyEquipmentOptions::new(
          get_buy_equipment_option_node: resolve('get.buy_equipment_option_node'),
          get_next_player_node: resolve('get.next_player_node'),
          get_pass_option_node: resolve('get.pass_option_node')).method(:call)
      end

      register :process_landing_on_space do
        player_moved = SpyAlleyApplication::DependencyContainer
          .resolve('game_board_effects.player_moved')
        SpyAlleyApplication::Results::ProcessLandingOnSpace::new(
          get_player_movement_node: resolve('get.player_movement_node'),
          player_moved: player_moved).method(:call)
      end

      register :process_move_options do
        move_options = SpyAlleyApplication::DependencyContainer
          .resolve('game_board_effects.move_options')
        SpyAlleyApplication::Results::ProcessMoveOptions::new(
          move_options: move_options,
          process_landing_on_space: resolve(:process_landing_on_space),
          process_next_turn_options: resolve(:process_next_turn_options)).method(:call)
      end

      register :process_next_turn_options do
        SpyAlleyApplication::Results::ProcessStartOfTurnOptions::new(
          get_roll_die_option_node: resolve('get.roll_die_option_node'),
          get_use_move_card_option_node: resolve('get.use_move_card_option_node'),
          get_make_accusation_option_node: resolve('get.make_accusation_option_node'),
          get_next_player_node: resolve('get.next_player_node'),
          get_move_option_node: resolve('get.move_option_node')).method(:call)
      end

      register :process_passing_spaces do
        money_gained_or_lost = SpyAlleyApplication::DependencyContainer
          .resolve('game_board_effects.money_gained_or_lost')
        SpyAlleyApplication::Results::ProcessPassingSpaces::new(
          get_money_gained_node: resolve('get.money_gained_node'),
          money_gained_or_lost: money_gained_or_lost,
          process_landing_on_space: resolve(:process_landing_on_space),
          process_move_options: resolve(:process_move_options))
      end
    end
  end
end

