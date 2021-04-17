# frozen string_literal: true

require 'dry-types'
require 'spy_alley_application/models/game_board'
require 'spy_alley_application/types/player'

i = Class.new do
  def call(game_board)
    game_board[:players] = game_board[:players]&.map do |player|
      SpyAlleyApplication::Types::Player.call(player.to_h)
    end
    game_board = SpyAlleyApplication::Models::GameBoard.call(game_board)
    players = game_board.players
    all_players_have_different_ids_seats_and_spy_identities(players)
    verify_current_seat_is_valid(players, game_board.game_state.seat)
    game_board
  end

  def all_players_have_different_ids_seats_and_spy_identities(players)
    id_list = []
    seat_list = []
    spy_list = []
    players.each do |player|
      if id_list.include?(player.id)
        raise Dry::Types::ConstraintError::new(
          'All players have distinct ids', players.map(&:id))
      end
      if seat_list.include?(player.seat)
        raise Dry::Types::ConstraintError::new(
          'All players have distinct seats', players.map(&:seat))
      end
      if spy_list.include?(player.spy_identity)
        raise Dry::Types::ConstraintError::new(
          'All players have distinct spy_identities', players.map(&:spy_identity))
      end
      id_list.push player.id
      seat_list.push player.seat
      spy_list.push player.spy_identity
    end
  end

  def verify_current_seat_is_valid(players, seat)
    seat_list = players.map(&:id)
    if !seat_list.include?(seat)
      raise Dry::Types::ConstraintError::new(
        "The seat whose turn it is not in the player list (#{seat_list})", seat)
    end
  end
end.new

SpyAlleyApplication::Types::GameBoard = Types::Constructor(Class){|value| i.call(value)}

