# frozen string literal: true

require 'dry-initializer'

module SpyAlleyApplication
  module Actions
    class MakeAccusation
      include Dry::Initializer.define -> do
        option :process_eliminating_player, type: ::Types::Callable, reader: :private
        option :process_next_turn_options, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, target_player_id:, nationality:)
        player = game_board.current_player
        target_player = game_board.players.find{|p| p.id.eql?(target_player_id)}
        at_risk_accusation = game_board.game_state.accept(self)
        if_incorrect = at_risk_accusation ? process_eliminating_player : process_next_turn_options
        if target_player.spy_identity.eql?(nationality)
          process_eliminating_player.(
            game_board: game_board,
            change_orders: change_orders,
            eliminating_player: player,
            eliminated_player: target_player)
        else
          if_incorrect.(
            game_board: game_board,
            change_orders: change_orders,
            eliminating_player: target_player,
            eliminated_player: player)
        end
      end

      def handle_spy_eliminator(*args);false;end
      def handle_start_of_turn(*args);true;end
    end
  end
end

