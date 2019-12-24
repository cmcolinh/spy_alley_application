# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Actions::ChooseIdentityAction do
  let(:player_model, &->{PlayerMock::new})
  let(:opponent_models, &->{[PlayerMock::new(seat: 5)]})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash_no_spy_eliminator) do |identity|
    ->(identity) do
      {
        player_action: 'choose_spy_identity',
        nationality:    identity,
        next_player_up: 5
      }
    end
  end
  let(:action_hash_spy_eliminator) do |identity|
    ->(identity) do
      {
        player_action: 'choose_spy_identity',
        nationality:    identity,
        next_player_up: 1,
        remaining_choices: [5]
      }
    end
  end
  let(:next_player_options, &->{CallableStub::new})
  let(:choose_spy_identity) do
    SpyAlleyApplication::Actions::ChooseIdentityAction::new(next_player_options: next_player_options)
  end

  describe '#call' do
    describe 'not continuing to make spy eliminator accusations' do
      let(:calling_method) do
        ->(identity) do
          choose_spy_identity.(
            player_model:  player_model,
            opponent_models: opponent_models,
            change_orders: change_orders,
            action_hash:   action_hash_no_spy_eliminator.(identity)
          )
        end
      end
      it 'calls change_orders#choose_new_spy_identity_action once' do
        calling_method.('russian')
        expect(change_orders.times_called[:choose_new_spy_identity_action]).to eql 1
      end
      it 'does not call change_orders#add_spy_eliminator_option' do
        calling_method.('russian')
        expect(change_orders.times_called[:add_spy_eliminator_option]).to eql 0
      end
      it 'call next_player_options' do
        calling_method.('russian')
        expect(next_player_options.called_with).not_to eql({})
      end
    end
    describe 'continuing to make spy eliminator accusations' do
      let(:calling_method_spy_eliminator) do
        ->(identity) do
          choose_spy_identity.(
            player_model:  player_model,
            opponent_models: opponent_models,
            change_orders: change_orders,
            action_hash:   action_hash_spy_eliminator.(identity)
          )
        end
      end
      it 'calls change_orders#choose_new_spy_identity_action once' do
        calling_method_spy_eliminator.('russian')
        expect(change_orders.times_called[:choose_new_spy_identity_action]).to eql 1
      end
      it 'does not call change_orders#add_spy_eliminator_option' do
        calling_method_spy_eliminator.('russian')
        expect(change_orders.times_called[:add_spy_eliminator_option]).to eql 1
      end
      it 'call next_player_options' do
        calling_method_spy_eliminator.('russian')
        expect(next_player_options.called_with).to eql({})
      end
    end
  end
end
