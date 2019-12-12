# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Actions::MoveAction do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:move_result, &->{CallableStub::new})
  let(:action_hash) do |identity|
    ->(space_to_move) do
      {
        player_action: 'move',
        space:         space_to_move
      }
    end
  end
  let(:move, &->{SpyAlleyApplication::Actions::MoveAction::new(move_result: move_result)})

  describe '#move' do
    %w(1 2 1s).each do |space_to_move|
      describe "when space to move is '#{space_to_move}'" do
        let(:calling_method) do
          ->{move.(player_model: player_model, change_orders: change_orders, action_hash: action_hash.(space_to_move))}
        end

        it 'calls change_orders.add_move_action' do
          calling_method.()
          expect(change_orders.times_called[:add_move_action]).to eql(1)
        end
      end
    end
  end
end
