# frozen_string_literal: true

class CallableStub
  @called_with = nil
  def call(options={})
    @called_with = options
  end
  def called_with
    @called_with.dup
  end
end


RSpec.describe SpyAlleyApplication::Results::MoveDistanceResult do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do
    {
      player_action: 'roll',
    }
  end
  let(get_move_distance_result) do
    ->(opts:) do
      SpyAlleyApplication::Results::MoveDistanceResult::new(
        move_options_from: ->(options){opts},
        get_move_options_result: CallableStub::new,
        get_move_result: CallableStub::new
      )
    end
  end
  describe '#call' do
    it 'calls move_options_from if move_options_from returns multiple locations' do
end
