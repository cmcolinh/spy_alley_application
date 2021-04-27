# frozen string literal: true

require 'dry-initializer'
require 'spy_alley_application/types/validation_builder'

module SpyAlleyApplication
  module Validator
    class Builder
      include Dry::Initializer.define -> do
        option :process_next_turn_options, type: ::Types::Callable, reader: :private
        option :change_orders_initializer, type: ::Types::Callable, reader: :private
        option :wrap_result, type: ::Types::Hash
      end

      def call(game_board:, last_action_id:)
        current_player = game_board.current_player
        change_orders = change_orders_initializer.()
        options = {}
        change_orders = process_next_turn_options.(
          game_board: game_board,
          change_orders: change_orders)

        change_orders.changes.each do |option_node| 
          options = option_node.accept(self, options: options)
        end

        next_player_id = options[:next_player_id]
        options = options.reject{|k, v| k.eql?(:next_player_id)}
        
        validate_player_action_and_user = GameValidator::Validator::Base::new(
          legal_options: options.values.map{|o| o[:name]},
          current_player_id: next_player_id,
          last_action_id: last_action_id)

        fv = {}
        options.each do |k, v|
          builder = SpyAlleyApplication::Types::ValidationBuilder.call(v)
          fv[[v[:name], true]] = builder.build(admin?: true)
          fv[[v[:name], false]] = builder.build(admin?: false)
        end

        GameValidator::Validator::new(
          validate_player_action_and_user: validate_player_action_and_user,
          full_validator_for: fv)
      end

      def handle_buy_equipment_option(option_node, options:)
        options[:buy_equipment] = {
          name: 'buy_equipment',
          options: option_node.options,
          limit: option_node.limit,
          wrap_result: wrap_result[:buy_equipment]}
        options
      end

      def handle_choose_new_spy_identity_option(option_node, options:)
        options[:choose_new_spy_identity] = {
          name: 'choose_new_spy_identity',
          options: option_node.options,
          wrap_result: wrap_result[:choose_new_spy_identity]}
        options
      end

      def handle_confiscate_materials_option(option_node, options:)
        options[:confiscate_materials] ||= {
          name: 'confiscate_materials',
          wrap_result: wrap_result[:confiscate_materials]}
        options[:confiscate_materials][:target_player] = {
          target_player_id: option_node.target_player_id,
          targetable_equipment: option_node.targetable_equipment}
        options
      end

      def handle_make_accusation_option(option_node, options:)
        options[:make_accusation] = {
          name: 'make_accusation',
          player_id_list: option_node.player_id_list,
          wrap_result: wrap_result[:make_accusation]}
        options
      end

      def handle_move_option(option_node, options:)
        options[:move] = {
          name: 'move',
          options: option_node.options,
          wrap_result: wrap_result[:move]}
        options
      end

      def handle_next_player(option_node, options:)
        options[:next_player_id] = option_node.player_id
        options
      end

      def handle_pass_option(option_node, options:)
        options[:pass] = {
          name: 'pass',
          wrap_result: wrap_result[:pass]}
        options
      end
 
      def handle_roll_die_option(option_node, options:)
        options[:roll_die] = {
          name: 'roll_die',
          wrap_result: wrap_result[:roll_die]}
        options
      end

      def handle_use_move_card(option_node, options:)
        options[:use_move_card] = {
          name: 'use_move_card',
          card_list: option_node.card_list,
          wrap_result: wrap_result[:use_move_card]}
        options
      end
    end
  end
end

