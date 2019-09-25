# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Actions::ChooseIdentityAction do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do |identity|
    ->(identity) do
      {
        player_action: 'choose_spy_identity',
        nationality:    identity
      }
    end
  end
  let(:choose_spy_identity, &->{SpyAlleyApplication::Actions::ChooseIdentityAction::new})

  describe '#call' do
    let(:calling_method) do
      ->(identity) do
        choose_spy_identity.(
          player_model:  player_model,
          change_orders: change_orders,
          action_hash:   action_hash.(identity)
        )
      end
    end
    %w(french german spanish italian american russian).each do |identity|
      describe "when selecting the '#{identity}' it" do
        it 'returns the identity chosen' do
          expect(calling_method.(identity)).to eql identity
        end
      end
    end
    it 'calls change_orders#choose_new_spy_identity_action once' do
      calling_method.('russian')
      expect(change_orders.times_called[:choose_new_spy_identity_action]).to eql 1
    end
  end
end
