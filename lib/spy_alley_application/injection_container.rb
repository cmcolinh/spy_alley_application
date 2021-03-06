# frozen string literal: true

require 'change_orders'
require 'dry-auto_inject'
require 'dry-container'
require 'game_validator'
require 'spy_alley_application/actions/buy_equipment'
require 'spy_alley_application/actions/choose_new_spy_identity'
require 'spy_alley_application/actions/choose_space_to_move'
require 'spy_alley_application/actions/confiscate_materials'
require 'spy_alley_application/actions/generate_new_game'
require 'spy_alley_application/actions/make_accusation'
require 'spy_alley_application/actions/pass'
require 'spy_alley_application/actions/roll_die'
require 'spy_alley_application/actions/use_move_card'
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
require 'spy_alley_application/models/game_board/move_card_used'
require 'spy_alley_application/models/game_board/move_options'
require 'spy_alley_application/models/game_board/new_spy_identity_chosen'
require 'spy_alley_application/models/game_board/next_game_state'
require 'spy_alley_application/models/game_board/player_moved'
require 'spy_alley_application/models/game_board/spy_eliminator_options'
require 'spy_alley_application/new_game/assign_seats'
require 'spy_alley_application/new_game/assign_spy_identities'
require 'spy_alley_application/results/nodes/buy_equipment_option_node'
require 'spy_alley_application/results/nodes/choose_new_spy_identity_option_node'
require 'spy_alley_application/results/nodes/confiscate_materials_option_node'
require 'spy_alley_application/results/nodes/die_rolled_node'
require 'spy_alley_application/results/nodes/eliminated_player_node'
require 'spy_alley_application/results/nodes/equipment_gained_node'
require 'spy_alley_application/results/nodes/game_over_node'
require 'spy_alley_application/results/nodes/make_accusation_option_node'
require 'spy_alley_application/results/nodes/money_gained_node'
require 'spy_alley_application/results/nodes/money_lost_node'
require 'spy_alley_application/results/nodes/move_back_node'
require 'spy_alley_application/results/nodes/move_card_drawn_node'
require 'spy_alley_application/results/nodes/move_card_used_node'
require 'spy_alley_application/results/nodes/move_option_node'
require 'spy_alley_application/results/nodes/new_spy_identity_chosen_node'
require 'spy_alley_application/results/nodes/next_player_node'
require 'spy_alley_application/results/nodes/pass_option_node'
require 'spy_alley_application/results/nodes/player_movement_node'
require 'spy_alley_application/results/nodes/player_passed_node'
require 'spy_alley_application/results/nodes/result_game_board_node'
require 'spy_alley_application/results/nodes/roll_die_option_node'
require 'spy_alley_application/results/nodes/use_move_card_option_node'
require 'spy_alley_application/results/nodes/wild_card_gained_node'
require 'spy_alley_application/results/process_buy_equipment_options'
require 'spy_alley_application/results/process_eliminating_player'
require 'spy_alley_application/results/process_move_options'
require 'spy_alley_application/results/process_landing_on_space'
require 'spy_alley_application/results/process_next_turn_options'
require 'spy_alley_application/results/process_passing_spaces'
require 'spy_alley_application/results/process_proceeding_to_next_state'
require 'spy_alley_application/validator/builder'
require 'spy_alley_application/validator/new_game'
require 'spy_alley_application/validator/new_game_builder'

module SpyAlleyApplication
  class InjectionContainer
    extend Dry::Container::Mixin
    register :change_orders_initializer do
      new_change_orders = ChangeOrders::Container::new
      ->{new_change_orders}
    end

    namespace :actions do
      register :buy_equipment do
        equipment_bought = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.equipment_bought')
        get_equipment_gained_node = SpyAlleyApplication::InjectionContainer
          .resolve('results.get.equipment_gained_node')
        process_proceeding_to_next_state = SpyAlleyApplication::InjectionContainer
          .resolve('results.process_proceeding_to_next_state')
        SpyAlleyApplication::Actions::BuyEquipment::new(
          equipment_bought: equipment_bought,
          get_equipment_gained_node: get_equipment_gained_node,
          process_proceeding_to_next_state: process_proceeding_to_next_state).method(:call)
      end

      register :choose_new_spy_identity do
        get_new_spy_identity_chosen_node = SpyAlleyApplication::InjectionContainer
          .resolve('results.get.new_spy_identity_chosen_node')
        get_result_game_board_node = SpyAlleyApplication::InjectionContainer
          .resolve('results.get.result_game_board_node')
        new_spy_identity_chosen = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.new_spy_identity_chosen')
        process_proceeding_to_next_state = SpyAlleyApplication::InjectionContainer
          .resolve('results.process_proceeding_to_next_state')
        SpyAlleyApplication::Actions::ChooseNewSpyIdentity::new(
          get_new_spy_identity_chosen_node: get_new_spy_identity_chosen_node,
          get_result_game_board_node: get_result_game_board_node,
          new_spy_identity_chosen: new_spy_identity_chosen,
          process_proceeding_to_next_state: process_proceeding_to_next_state).method(:call)
      end

      register :choose_space_to_move do
        process_landing_on_space = SpyAlleyApplication::InjectionContainer
          .resolve('results.process_landing_on_space')
        SpyAlleyApplication::Actions::ChooseSpaceToMove::new(
          process_landing_on_space: process_landing_on_space).method(:call)
      end

      register :confiscate_materials do
        equipment_confiscated = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.equipment_confiscated')
        get_equipment_gained_node = SpyAlleyApplication::InjectionContainer
          .resolve('results.get.equipment_gained_node')
        get_wild_card_gained_node = SpyAlleyApplication::InjectionContainer
          .resolve('results.get.wild_card_gained_node')
        process_proceeding_to_next_state = SpyAlleyApplication::InjectionContainer
          .resolve('results.process_proceeding_to_next_state')
        SpyAlleyApplication::Actions::ConfiscateMaterials::new(
          equipment_confiscated: equipment_confiscated,
          get_equipment_gained_node: get_equipment_gained_node,
          get_wild_card_gained_node: get_wild_card_gained_node,
          process_proceeding_to_next_state: process_proceeding_to_next_state)
      end

      register :generate_new_game do
        get_result_game_board_node = SpyAlleyApplication::InjectionContainer
          .resolve('results.get.result_game_board_node')
        process_next_turn_options = SpyAlleyApplication::InjectionContainer
          .resolve('results.process_next_turn_options')
        SpyAlleyApplication::Actions::GenerateNewGame::new(
          get_result_game_board_node: get_result_game_board_node,
          process_next_turn_options: process_next_turn_options).method(:call)
      end

      register :make_accusation do
        process_eliminating_player = SpyAlleyApplication::InjectionContainer
          .resolve('results.process_eliminating_player')
        process_proceeding_to_next_state = SpyAlleyApplication::InjectionContainer
          .resolve('results.process_proceeding_to_next_state')
        SpyAlleyApplication::Actions::MakeAccusation::new(
          process_eliminating_player: process_eliminating_player,
          process_proceeding_to_next_state: process_proceeding_to_next_state).method(:call)
      end

      register :pass do
        get_player_passed_node = SpyAlleyApplication::InjectionContainer
          .resolve('results.get.player_passed_node')
        process_proceeding_to_next_state = SpyAlleyApplication::InjectionContainer
          .resolve('results.process_proceeding_to_next_state')
        SpyAlleyApplication::Actions::Pass::new(
          get_player_passed_node: get_player_passed_node,
          process_proceeding_to_next_state: process_proceeding_to_next_state).method(:call)
      end

      register :roll_die do
        execute_die_roll = SpyAlleyApplication::InjectionContainer
          .resolve('results.execute_die_roll')
        get_die_rolled_node = SpyAlleyApplication::InjectionContainer
          .resolve('results.get.die_rolled_node')
        process_passing_spaces = SpyAlleyApplication::InjectionContainer
          .resolve('results.process_passing_spaces')
        SpyAlleyApplication::Actions::RollDie::new(
          execute_die_roll: execute_die_roll,
          get_die_rolled_node: get_die_rolled_node,
          process_passing_spaces: process_passing_spaces).method(:call)
      end

      register :use_move_card do
        get_move_card_used_node = SpyAlleyApplication::InjectionContainer
          .resolve('results.get.move_card_used_node')
        move_card_used = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.move_card_used')
        process_passing_spaces =
          SpyAlleyApplication::InjectionContainer.resolve('results.process_passing_spaces')
        SpyAlleyApplication::Actions::UseMoveCard::new(
          get_move_card_used_node: get_move_card_used_node,
          move_card_used: move_card_used,
          process_passing_spaces: process_passing_spaces).method(:call)
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
        SpyAlleyApplication::Models::GameBoard::ConfiscateMaterialsOptionState::new(
          next_game_state: resolve(:next_game_state)).method(:call)
      end

      register :eliminate_player do
        SpyAlleyApplication::Models::GameBoard::EliminatePlayer::new.method(:call)
      end

      register :equipment_bought do
        SpyAlleyApplication::Models::GameBoard::EquipmentBought::new.method(:call)
      end

      register :equipment_confiscated do
        SpyAlleyApplication::Models::GameBoard::EquipmentConfiscated::new.method(:call)
      end

      register :embassy_victory do
        SpyAlleyApplication::Models::GameBoard::EmbassyVictory::new.method(:call)
      end

      register :free_gift_drawn do
        SpyAlleyApplication::Models::GameBoard::FreeGiftDrawn::new.method(:call)
      end

      register :money_gained_or_lost do
        SpyAlleyApplication::Models::GameBoard::MoneyGainedOrLost::new.method(:call)
      end

      register :move_card_drawn do
        SpyAlleyApplication::Models::GameBoard::MoveCardDrawn::new.method(:call)
      end

      register :move_card_used do
        SpyAlleyApplication::Models::GameBoard::MoveCardUsed::new.method(:call)
      end

      register :move_options do
        SpyAlleyApplication::Models::GameBoard::MoveOptions::new.method(:call)
      end

      register :new_spy_identity_chosen do
        SpyAlleyApplication::Models::GameBoard::NewSpyIdentityChosen::new.method(:call)
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

    namespace :new_game do
      register :assign_seats do
        SpyAlleyApplication::NewGame::AssignSeats::new
      end

      register :assign_spy_identities do
        SpyAlleyApplication::NewGame::AssignSpyIdentities::new
      end

      register :validate_new_game do
        SpyAlleyApplication::Validator::NewGame::new
      end
    end

    namespace :results do
      register :execute_die_roll do
        ->{rand(6) + 1}
      end

      namespace :get do
        register :buy_equipment_option_node do
          ->(options:, limit:) do
            SpyAlleyApplication::Results::Nodes::BuyEquipmentOptionNode::new(
              options: options,
              limit: limit)
          end
        end

        register :choose_new_spy_identity_option_node do
          ->(options:) do
            SpyAlleyApplication::Results::Nodes::ChooseNewSpyIdentityOptionNode::new(
              options: options)
          end
        end

        register :confiscate_materials_option_node do
          ->(target_player_id:, targetable_equipment:) do
            SpyAlleyApplication::Results::Nodes::ConfiscateMaterialsOptionNode::new(
              target_player_id: target_player_id,
              targetable_equipment: targetable_equipment)
          end
        end

        register :die_rolled_node do
          ->(number_rolled:) do
            SpyAlleyApplication::Results::Nodes::DieRolledNode::new(
              number_rolled: number_rolled)
          end
        end

        register :eliminated_player_node do
          ->(eliminating_player:, eliminated_player:) do
            SpyAlleyApplication::Results::Nodes::EliminatedPlayerNode::new(
              eliminating_player: eliminating_player,
              eliminated_player: eliminated_player)
          end
        end

        register :equipment_gained_node do
          ->(player_id:, equipment:, reason:) do
            SpyAlleyApplication::Results::Nodes::EquipmentGainedNode::new(
              player_id: player_id,
              equipment: equipment,
              reason: reason)
          end
        end

        register :game_over_node do
          ->(winning_player_id:, reason:) do
            SpyAlleyApplication::Results::Nodes::GameOverNode::new(
              winning_player_id: winning_player_id, reason: reason)
          end
        end

        register :make_accusation_option_node do
          ->(player_id_list:) do
            SpyAlleyApplication::Results::Nodes::MakeAccusationOptionNode::new(
              player_id_list: player_id_list)
          end
        end

        register :money_gained_node do
          ->(player_id:, money_gained:, reason:) do
            SpyAlleyApplication::Results::Nodes::MoneyGainedNode::new(
              player_id: player_id,
              money_gained: money_gained,
              reason: reason)
          end
        end

        register :money_lost_node do
          ->(player_id:, money_lost:, reason:) do
            SpyAlleyApplication::Results::Nodes::MoneyLostNode::new(
              player_id: player_id,
              money_gained: money_gained,
              reason: reason)
          end
        end

        register :move_back_node do
          ->(player_id:, player_moved:) do
            SpyAlleyApplication::Results::Nodes::MoveBackNode::new(
              player_id: player_id,
              player_moved: player_moved)
          end
        end

        register :move_card_drawn_node do
          ->(player_id:, card:) do
            SpyAlleyApplication::Results::Nodes::MoveCardDrawnNode::new(
              player_id: player_id,
              card: card)
          end
        end

        register :move_card_used_node do
          ->(player_id:, card:) do
            SpyAlleyApplication::Results::Nodes::MoveCardUsedNode::new(
              player_id: player_id,
              card: card)
          end
        end

        register :move_option_node do
          ->(options:) do
            SpyAlleyApplication::Results::Nodes::MoveOptionNode::new(
              options: options)
          end
        end

        register :new_spy_identity_chosen_node do
          ->(nationality:) do
            SpyAlleyApplication::Results::Nodes::NewSpyIdentityChosenNode::new(
              nationality: nationality)
          end
        end

        register :next_player_node do
          ->(player_id:) do
            SpyAlleyApplication::Results::Nodes::NextPlayerNode::new(player_id: player_id)
          end
        end

        register :pass_option_node do
          pass_option_node = SpyAlleyApplication::Results::Nodes::PassOptionNode::new
          ->{pass_option_node}
        end

        register :player_movement_node do
          ->(player_id:, space_id:) do
            SpyAlleyApplication::Results::Nodes::PlayerMovementNode::new(
              player_id: player_id,
              space_id: space_id)
          end
        end

        register :player_passed_node do
          player_passed_node = SpyAlleyApplication::Results::Nodes::PlayerPassedNode::new
          ->{player_passed_node}
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

        register :wild_card_gained_node do
          ->(player_id:, number_gained:, reason:) do
            SpyAlleyApplication::Results::Nodes::WildCardGainedNode::new(
              player_id: player_id,
              number_gained: number_gained,
              reason: reason)
          end
        end
      end

      register :process_buy_equipment_options do
        SpyAlleyApplication::Results::ProcessBuyEquipmentOptions::new(
          get_buy_equipment_option_node: resolve('get.buy_equipment_option_node'),
          get_next_player_node: resolve('get.next_player_node'),
          get_pass_option_node: resolve('get.pass_option_node')).method(:call)
      end

      register :process_eliminating_player do
        eliminate_player = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.eliminate_player')
        SpyAlleyApplication::Results::ProcessEliminatingPlayer::new(
          get_eliminated_player_node: resolve('get.eliminated_player_node'),
          get_game_over_node: resolve('get.game_over_node'),
          get_result_game_board_node: resolve('get.result_game_board_node'),
          eliminate_player: eliminate_player,
          process_next_turn_options: resolve(:process_next_turn_options)).method(:call)
      end

      register :process_landing_on_space do
        black_market_option_state = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.black_market_option_state')
        buy_equipment_option_state = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.buy_equipment_option_state')
        buy_password_option_state = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.buy_password_option_state')
        confiscate_materials_option_state = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.confiscate_materials_option_state')
        embassy_victory = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.embassy_victory')
        free_gift_drawn = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.free_gift_drawn')
        money_gained_or_lost = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.money_gained_or_lost')
        move_card_drawn = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.move_card_drawn')
        next_game_state = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.next_game_state')
        player_moved = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.player_moved')
        spy_eliminator_options = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.spy_eliminator_options')
        SpyAlleyApplication::Results::ProcessLandingOnSpace::new(
          black_market_option_state: black_market_option_state,
          buy_equipment_option_state: buy_equipment_option_state,
          buy_password_option_state: buy_password_option_state,
          confiscate_materials_option_state: confiscate_materials_option_state,
          embassy_victory: embassy_victory,
          free_gift_drawn: free_gift_drawn,
          get_equipment_gained_node: resolve('get.equipment_gained_node'),
          get_game_over_node: resolve('get.game_over_node'),
          get_money_gained_node: resolve('get.money_gained_node'),
          get_money_lost_node: resolve('get.money_lost_node'),
          get_move_card_drawn_node: resolve('get.move_card_drawn_node'),
          get_player_movement_node: resolve('get.player_movement_node'),
          get_result_game_board_node: resolve('get.result_game_board_node'),
          get_wild_card_gained_node: resolve('get.wild_card_gained_node'),
          money_gained_or_lost: money_gained_or_lost,
          move_card_drawn: move_card_drawn,
          next_game_state: next_game_state,
          player_moved: player_moved,
          process_next_turn_options: resolve(:process_next_turn_options),
          process_proceeding_to_next_state: resolve(:process_proceeding_to_next_state),
          spy_eliminator_options: spy_eliminator_options).method(:call)
      end

      register :process_move_options do
        move_options = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.move_options')
        SpyAlleyApplication::Results::ProcessMoveOptions::new(
          move_options: move_options,
          process_landing_on_space: resolve(:process_landing_on_space),
          process_next_turn_options: resolve(:process_next_turn_options)).method(:call)
      end

      register :process_next_turn_options do
        choose_new_spy_identity_option_node = resolve('get.choose_new_spy_identity_option_node')
        SpyAlleyApplication::Results::ProcessNextTurnOptions::new(
          get_buy_equipment_option_node: resolve('get.buy_equipment_option_node'),
          get_choose_new_spy_identity_option_node: choose_new_spy_identity_option_node,
          get_confiscate_materials_option_node: resolve('get.confiscate_materials_option_node'),
          get_make_accusation_option_node: resolve('get.make_accusation_option_node'),
          get_next_player_node: resolve('get.next_player_node'),
          get_move_option_node: resolve('get.move_option_node'),
          get_pass_option_node: resolve('get.pass_option_node'),
          get_roll_die_option_node: resolve('get.roll_die_option_node'),
          get_use_move_card_option_node: resolve('get.use_move_card_option_node')).method(:call)
      end

      register :process_passing_spaces do
        money_gained_or_lost = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.money_gained_or_lost')
        SpyAlleyApplication::Results::ProcessPassingSpaces::new(
          get_money_gained_node: resolve('get.money_gained_node'),
          money_gained_or_lost: money_gained_or_lost,
          process_landing_on_space: resolve(:process_landing_on_space),
          process_move_options: resolve(:process_move_options)).method(:call)
      end

      register :process_proceeding_to_next_state do
        next_game_state = SpyAlleyApplication::InjectionContainer
          .resolve('game_board_effects.next_game_state')
        SpyAlleyApplication::Results::ProcessProceedingToNextState::new(
          get_result_game_board_node: resolve('get.result_game_board_node'),
          next_game_state: next_game_state,
          process_next_turn_options: resolve(:process_next_turn_options)).method(:call)
      end
    end

    register :build_new_game_validator do
      SpyAlleyApplication::Validator::NewGameBuilder::new(
        assign_seats: resolve('new_game.assign_seats'),
        assign_spy_identities: resolve('new_game.assign_spy_identities'),
        generate_new_game: resolve('actions.generate_new_game'),
        validate_new_game: resolve('new_game.validate_new_game'))
    end

    register :build_validator do
      SpyAlleyApplication::Validator::Builder::new(
        process_next_turn_options: resolve('results.process_next_turn_options'),
        change_orders_initializer: resolve(:change_orders_initializer),
        wrap_result: resolve(:wrap_result))
    end

    register :wrap_result do
      dc = SpyAlleyApplication::InjectionContainer
      wrap_result = ->(execute) do
        ->(successful_result) do
          GameValidator::Validator::Result::new(
            result: successful_result,
            execute: execute)
        end
      end

      {
        buy_equipment: wrap_result.(dc.resolve('actions.buy_equipment')),
        choose_new_spy_identity: wrap_result.(dc.resolve('actions.choose_new_spy_identity')),
        confiscate_materials: wrap_result.(dc.resolve('actions.confiscate_materials')),
        make_accusation: wrap_result.(dc.resolve('actions.make_accusation')),
        move: wrap_result.(dc.resolve('actions.choose_space_to_move')),
        pass: wrap_result.(dc.resolve('actions.pass')),
        roll_die: wrap_result.(dc.resolve('actions.roll_die')),
        use_move_card: wrap_result.(dc.resolve('actions.use_move_card'))
      }
    end
  end
end

