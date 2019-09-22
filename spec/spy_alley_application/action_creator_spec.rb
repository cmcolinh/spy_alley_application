# frozen_string_literal: true

require 'dry/validation'

# this mock validator will simply return the imput, so I can create any Dry::Validation::Result I want
class MockValidator < Dry::Validation::Contract
  schema do
    required(:player_action).filled(:string)
    optional(:choose_result).filled(:integer, included_in?: [1,2,3,4,5,6])
    optional(:card_to_use).filled(:integer, included_in?: [1,2,3,4,5,6])
    optional(:nationality).filled(:string, included_in?: %w(french german spanish italian american russian))
    optional(:player_to_accuse).filled(:string, included_in?: (1..6).map{|num| "seat_#{num}"})
    optional(:equipment_to_buy).filled(:array)
    optional(:space).filled(:string)
    optional(:player_to_confiscate_from).filled(:string, included_in?: (1..6).map{|num| "seat_#{num}"})
    optional(:equipment_to_confiscate).filled(:string)
    optional(:free_accusation).filled(:bool)
  end
end
RSpec.describe SpyAlleyApplication::ActionCreator do
  let(:validate, &->{->(options){MockValidator::new.(options)}})
  let(:create_action_from, &->{->(options){SpyAlleyApplication::ActionCreator::new.(validate.(options))}})

  describe 'creates the correct type of action' do
    it 'builds a move distance action when the result is a roll action' do
      expect(
        create_action_from.(player_action: 'roll')
      ).to be_a SpyAlleyApplication::Actions::MoveDistanceAction
    end

    it "builds a move distance action when the result contains 'choose_result'" do
      expect(
        create_action_from.(
          player_action: 'roll',
          choose_result: 1
        )
      ).to be_a SpyAlleyApplication::Actions::MoveDistanceAction
    end

    it 'builds a move distance action when the result is a use_move_card action' do
      expect(
        create_action_from.(
          player_action: 'use_move_card',
          card_to_use:   1
        )
      ).to be_a SpyAlleyApplication::Actions::MoveDistanceAction
    end

    it 'builds a pass action when the result is a pass action' do
      expect(create_action_from.(player_action: 'pass')).to be_a SpyAlleyApplication::Actions::PassAction
    end

    it 'builds a buy equipment action when the result is to buy equipment' do
      expect(
        create_action_from.(
          player_action:    'buy_equipment',
          equipment_to_buy: ['french password']
        )
      ).to be_a SpyAlleyApplication::Actions::BuyEquipmentAction
    end

    it 'builds a make at risk accusation action when the result is to make at risk accusation' do
      expect(
        create_action_from.(
          player_action: 'make_accusation',
          nationality:   'french'
        )
      ).to be_a SpyAlleyApplication::Actions::AtRiskAccusationAction
    end

    it 'builds a free accusation action when the result is to make a free accusation' do
      expect(
        create_action_from.(
          player_action:    'make_accusation',
          nationality:      'french',
          free_accusation: true
        )
      ).to be_a SpyAlleyApplication::Actions::FreeAccusationAction
    end

    it 'builds a confiscate materials action when the result is to make a confiscate materials accusation' do
      expect(
        create_action_from.(
          player_action:             'confiscate_materials',
          player_to_confiscate_from: 'seat_2',
          equipment_to_confiscate:   'french password'
        )
      ).to be_a SpyAlleyApplication::Actions::ConfiscateMaterialsAction
    end

    it 'builds a choose identity action when the result is to choose a new spy identity' do
      expect(
        create_action_from.(
          player_action: 'choose_spy_identity',
          nationality:   'french'
        )
      ).to be_a SpyAlleyApplication::Actions::ChooseIdentityAction
    end
  end
  describe 'creates the correct type of MoveDistanceAction' do
    it 'utilizes a roll action when the result is a roll action' do
      expect(
        create_action_from.(player_action: 'roll').move_action
      ).to be_a SpyAlleyApplication::Actions::MoveDistanceAction::RollAction
    end

    it "utilizes an admin roll action when the result contains 'choose_result'" do
      expect(
        create_action_from.(
          player_action: 'roll',
          choose_result: 1
        ).move_action
      ).to be_a SpyAlleyApplication::Actions::MoveDistanceAction::AdminRollAction
    end

    it 'utilizes a move card action when the result is a use_move_card action' do
      expect(
        create_action_from.(
          player_action: 'use_move_card',
          card_to_use:   1
        ).move_action
      ).to be_a SpyAlleyApplication::Actions::MoveDistanceAction::MoveCardAction
    end
  end
end

