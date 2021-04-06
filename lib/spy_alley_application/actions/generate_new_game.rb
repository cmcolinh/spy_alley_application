# frozen string literal: true

require 'dry-initializer'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Actions
    class GenerateNewGame
      include Dry::Initializer.define -> do
        option :get_result_game_board_node, type: ::Types::Callable, reader: :private
        option :process_start_of_turn_options, type: ::Types::Callable, reader: :private
        option :start_location, default: ->{{id: 0}}, reader: :private
      end
      def call(seat_assignments:, change_orders:)
        cnt = seat_assignments.size
        players = seat_assignments.map{|s| get_player(s[:id], s[:seat], s[:spy_identity], cnt)}
        starting_player =
        game_board = SpyAlleyApplication::Types::GameBoard.call(
          players: players,
          move_card_pile: generate_move_card_deck,
          free_gift_pile: generate_free_gift_deck,
          game_state: starting_state(players))
        starting_player_id = players.find{|p| p[:seat].eql?(game_board.game_state.seat)}[:id]
        other_ids = players.reject{|p| p[:seat].eql?(game_board.game_state.seat)}.map{|p| p[:id]}

        process_start_of_turn_options.(game_board: game_board,
          change_orders: change_orders.push(get_result_game_board_node.(game_board: game_board)))
      end

      private
      def get_player(id, seat, spy_identity, num_players)
        {
          id: id,
          seat: seat,
          location: start_location,
          spy_identity: spy_identity,
          money: 10 * num_players,
          move_cards: [].freeze,
          equipment: [].freeze,
          wild_cards: 0,
          active?: true
        }
      end

      def generate_move_card_deck
        move_cards = []
        (1..6).to_a.each do |num|
          move_cards = move_cards + ([num] * 6)
        end
        move_cards.shuffle
      end

      def generate_free_gift_deck
        free_gifts = ['wild card'] * 4
        ['french', 'german', 'spanish', 'italian', 'american', 'russian'].each do |nationality|
          ['password', 'disguise', 'codebook', 'key'].each do |equipment_type|
            free_gifts = free_gifts + (["#{nationality} #{equipment_type}"] * 2)
          end
        end
        free_gifts.shuffle
      end

      def starting_state(players)
        starting_seat = players.map{|p| p[:seat]}.min
        {name: 'start_of_turn', seat: starting_seat}
      end
    end
  end
end

