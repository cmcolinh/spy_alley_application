# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::ExecuteAction do
  let(:action, &->{{player_action: 'use_move_card', card_to_use: 1}})
  let(:next_action_options) do
    { accept_roll: true,
      accept_use_move_card: [1],
      accept_make_accusation: {
        nationality: %w(french german spanish italian american russian),
        player: ['seat_2']
      }
    }
  end
  let(:player_models, &->{[PlayerMock::new(seat: 1), PlayerMock::new(seat: 2)]})
  let(:next_player, &->{1})
  let(:decks_model, &->{DecksModelMock::new})
  let(:execute_action, &->{SpyAlleyApplication::ExecuteAction::new})
  describe '#call' do
    it 'does stuff' do
      result = execute_action.(
        action: action,
        next_action_options: next_action_options,
        player_models: player_models,
        decks_model: decks_model,
        next_player: next_player
      )
      puts result
    end
  end
end
