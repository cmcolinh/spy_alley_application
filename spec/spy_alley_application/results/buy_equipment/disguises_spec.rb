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
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(do_nothing.called_with).not_to eql({})
  end
  it 'does not call buy_equipment if the player has no money' do
    player_model = PlayerMock::new(money: 0, equipment: [])
    buy_disguises.(
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
    buy_disguises.(
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
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with).to eql({})
  end
  it 'does calls buy_equipment offering to buy any of the unowned disguises if the player has ' +
    'at least 5 money and does not own all of the disguises' do

    player_model = PlayerMock::new(money: 5, equipment: ['french disguise', 'german disguise'])
    buy_disguises.(
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
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
  end
  it 'does calls buy_equipment giving a buy limit of 2 if the player has between 10 and 14 money ' +
    'and is missing at least two disguises' do

    player_model = PlayerMock::new(money: 10, equipment: ['french disguise', 'german disguise'])
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(2)
  end
  it 'does calls buy_equipment giving a buy limit of 3 if the player has between 15 and 19 money ' +
    'and is missing at least three disguises' do

    player_model = PlayerMock::new(money: 15, equipment: ['french disguise', 'german disguise'])
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(3)
  end
  it 'does calls buy_equipment giving a buy limit of 4 if the player has between 20 and 24 money ' +
    'and is missing at least four disguises' do

    player_model = PlayerMock::new(money: 20, equipment: ['french disguise'])
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(4)
  end
  it 'does calls buy_equipment giving a buy limit of 5 if the player has between 25 and 29 money ' +
    'and is missing at least five disguises' do

    player_model = PlayerMock::new(money: 25, equipment: ['french password'])
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(5)
  end
  it 'does calls buy_equipment giving a buy limit of 6 if the player has at least 30 money ' +
    'and does not have any disguises' do

    player_model = PlayerMock::new(money: 100, equipment: ['french password'])
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(6)
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
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
  end
  it 'does calls buy_equipment giving a buy limit of 2 if the player has enough money to buy all ' +
    'of the disguises, but is only missing two of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french disguise',
        'italian disguise',
        'american disguise',
        'russian disguise'
      ]
    )
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(2)
  end
  it 'does calls buy_equipment giving a buy limit of 3 if the player has enough money to buy all ' +
    'of the disguises, but is only missing three of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french disguise',
        'italian disguise',
        'russian disguise'
      ]
    )
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(3)
  end
  it 'does calls buy_equipment giving a buy limit of 4 if the player has enough money to buy all ' +
    'of the disguises, but is only missing four of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french disguise',
        'russian disguise'
      ]
    )
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(4)
  end
  it 'does calls buy_equipment giving a buy limit of 5 if the player has enough money to buy all ' +
    'of the disguises, but is only missing five of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'russian disguise'
      ]
    )
    buy_disguises.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(5)
  end
end
