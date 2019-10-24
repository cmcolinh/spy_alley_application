# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::BuyEquipment::Codebooks do
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:do_nothing, &->{CallableStub::new})
  let(:buy_equipment, &->{CallableStub::new})
  let(:buy_codebooks) do
    SpyAlleyApplication::Results::BuyEquipment::Codebooks::new(
      do_nothing: do_nothing,
      buy_equipment: buy_equipment
    )
  end
  it 'calls do_nothing if the player has no money' do
    player_model = PlayerMock::new(money: 0, equipment: [])
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(do_nothing.called_with).not_to eql({})
  end
  it 'does not call buy_equipment if the player has no money' do
    player_model = PlayerMock::new(money: 0, equipment: [])
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with).to eql({})
  end
  it 'calls do_nothing if the player already has all of the codebooks' do
    player_model = PlayerMock::new(
      money: 50,
      equipment: [
        'french codebook',
        'german codebook',
        'spanish codebook',
        'italian codebook',
        'american codebook',
        'russian codebook'
      ]
    )
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(do_nothing.called_with).not_to eql({})
  end
  it 'does not call buy_equipment if the player already has all of the codebooks' do
    player_model = PlayerMock::new(
      money: 50,
      equipment: [
        'french codebook',
        'german codebook',
        'spanish codebook',
        'italian codebook',
        'american codebook',
        'russian codebook'
      ]
    )
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with).to eql({})
  end
  it 'does calls buy_equipment offering to buy any of the unowned codebooks if the player has ' +
    'at least 5 money and does not own all of the codebooks' do

    player_model = PlayerMock::new(money: 5, equipment: ['french codebook', 'german codebook'])
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_options]).to match_array([
      'spanish codebook',
      'italian codebook',
      'american codebook',
      'russian codebook'
    ])
  end
  it 'does calls buy_equipment giving a buy limit of 1 if the player has between 15 and 29 money ' +
    'and does not have all of the codebooks' do

    player_model = PlayerMock::new(money: 15, equipment: ['french codebook', 'german codebook'])
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
  end
  it 'does calls buy_equipment giving a buy limit of 2 if the player has between 30 and 44 money ' +
    'and is missing at least two codebooks' do

    player_model = PlayerMock::new(money: 30, equipment: ['french codebook', 'german codebook'])
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(2)
  end
  it 'does calls buy_equipment giving a buy limit of 3 if the player has between 45 and 59 money ' +
    'and is missing at least three codebooks' do

    player_model = PlayerMock::new(money: 45, equipment: ['french codebook', 'german codebook'])
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(3)
  end
  it 'does calls buy_equipment giving a buy limit of 4 if the player has between 60 and 74 money ' +
    'and is missing at least four codebooks' do

    player_model = PlayerMock::new(money: 60, equipment: ['french codebook'])
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(4)
  end
  it 'does calls buy_equipment giving a buy limit of 5 if the player has between 75 and 89 money ' +
    'and is missing at least five codebooks' do

    player_model = PlayerMock::new(money: 75, equipment: ['french password'])
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(5)
  end
  it 'does calls buy_equipment giving a buy limit of 6 if the player has at least 90 money ' +
    'and does not have any codebooks' do

    player_model = PlayerMock::new(money: 100, equipment: ['french password'])
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(6)
  end
  it 'does calls buy_equipment giving a buy limit of 1 if the player has enough money to buy all ' +
    'of the codebooks, but is only missing one of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french codebook',
        'german codebook',
        'italian codebook',
        'american codebook',
        'russian codebook'
      ]
    )
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
  end
  it 'does calls buy_equipment giving a buy limit of 2 if the player has enough money to buy all ' +
    'of the codebooks, but is only missing two of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french codebook',
        'italian codebook',
        'american codebook',
        'russian codebook'
      ]
    )
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(2)
  end
  it 'does calls buy_equipment giving a buy limit of 3 if the player has enough money to buy all ' +
    'of the codebooks, but is only missing three of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french codebook',
        'italian codebook',
        'russian codebook'
      ]
    )
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(3)
  end
  it 'does calls buy_equipment giving a buy limit of 4 if the player has enough money to buy all ' +
    'of the codebooks, but is only missing four of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french codebook',
        'russian codebook'
      ]
    )
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(4)
  end
  it 'does calls buy_equipment giving a buy limit of 5 if the player has enough money to buy all ' +
    'of the codebooks, but is only missing five of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'russian codebook'
      ]
    )
    buy_codebooks.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(5)
  end
end
