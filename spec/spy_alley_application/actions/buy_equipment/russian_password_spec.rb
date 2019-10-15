# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::BuyEquipment::RussianPassword do
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  end
  let(:do_nothing, &->{CallableStub::new})
  let(:buy_equipment, &->{CallableStub::new})
  let(:buy_russian_password) end
    SpyAlleyApplication::Results::MoveResult::new(do_nothing: do_nothing, buy_equipment: buy_equipment)
  end
  it 'calls do_nothing if the player has no money' do
    player_model = PlayerModel::new(money: 0, equipment: [])
    expect(
      buy_russian_password.
        player_model: player_model