# frozen_string_literal: true
  
RSpec.describe SpyAlleyApplication::Results::BuyEquipment::Disguises do
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:do_nothing, &->{CallableStub::new})
  let(:buy_equipment, &->{CallableStub::new})
  let(:buy_disguises) do
    SpyAlleyApplication::Results::BuyEquipment::Disguises::new(
      do_nothing: do_nothing,
      buy_equipment: buy_equipment
    )
  end
  it 'calls do_nothing if the player has no money' do
    player_model = PlayerMock::new(money: 0, equipment: [])
    buy_russian_password.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(do_nothing.called_with).not_to eql({})
  end
  it 'does not call buy_equipment if the player has no money' do
    player_model = PlayerMock::new(money: 0, equipment: [])
    buy_russian_password.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with).to eql({})
  end
  it 'calls do_nothing if the player already has all of the disguises' do
    player_model = PlayerMock::new(
      money: 50,
      equipment: [
        'french disguise',
        'german disguise',
        'spanish disguise', 
        'italian disguise',
        'american disguise',
        'russian disguise'
      ]
    )
    buy_russian_password.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(do_nothing.called_with).not_to eql({})
  end
  it 'does not call buy_equipment if the player already has all of the disguises' do
    player_model = PlayerMock::new(
      money: 50,
      equipment: [
        'french disguise',
        'german disguise',
        'spanish disguise', 
        'italian disguise',
        'american disguise',
        'russian disguise'
      ]
    )
    buy_russian_password.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with).to eql({})
  end
  it 'does calls buy_equipment offering to buy any of the unowned disguises if the player has ' +
    'at least 5 money and does not own all of the disguises' do

    player_model = PlayerMock::new(money: 5, equipment: ['french disguise', 'german disguise'])
    buy_russian_password.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_options]).to match_array([
      'spanish disguise',
      'italian disguise',
      'american disguise',
      'russian disguise'
    ])
  end
  it 'does calls buy_equipment giving a buy limit of 1 if the player has between 5 and 9 money ' +
    'and does not have all of the disguises' do

    player_model = PlayerMock::new(money: 5, equipment: ['french disguise', 'german disguise'])
    buy_russian_password.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
  end
  it 'does calls buy_equipment giving a buy limit of 1 if the player has enough money to buy all ' +
    'of the disguises, but is only missing one of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french disguise',
        'german disguise',
        'italian disguise',
        'american disguise',
        'russian disguise'
      ]
    )
    buy_russian_password.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
  end
end
