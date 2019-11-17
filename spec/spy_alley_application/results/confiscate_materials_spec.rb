# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::ConfiscateMaterials do
  let(:player_model, &->{PlayerMock::new(location: '2s')})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do
    {
      player_action: 'roll'
    }
  end
  let(:confiscate_materials, &->{SpyAlleyApplication::Results::SpyEliminator::new})
  let(:opponent1, &->{PlayerMock.new(location: '0', seat: 2)})
  let(:opponent2, &->{PlayerMock.new(location: '1s', seat: 3)})
  let(:opponent3, &->{PlayerMock.new(location: '9s', seat: 4)})
  describe '#call' do
  end
end
