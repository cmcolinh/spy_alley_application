# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class BuyEquipment
      class BlackMarket
        extend Dry::Initializer
        @@all_passwords = %w(french german spanish italian american russian).map{|n| "#{n} password"}
        all_disguises = %w(french german spanish italian american russian).map{|n| "#{n} disguise"}
        @@all_passwords_and_disguises = @@all_passwords + all_disguises
        all_codebooks = %w(french german spanish italian american russian).map{|n| "#{n} codebook"}
        @@all_passwords_disguises_codebooks = @@all_passwords_and_disguises + all_codebooks
        all_keys = %w(french german spanish italian american russian).map{|n| "#{n} key"}
        @@all_equipment = @@all_passwords_disguises_codebooks + all_keys
        option :do_nothing, default: ->{SpyAlleyApplication::Results::NoActionResult::new}
        option :buy_equipment, default: ->{SpyAlleyApplication::Results::BuyEquipment::new}

        def call(player_model:, change_orders:, action_hash:, target_player_model: nil)
          equipment = []
          case player_model.money
          when 0
            equipment = []
          when 1..4
            equipment = @@all_passwords
          when 5..14
            equipment = @@all_passwords_and_disguises
          when 15..29
            equipment = @@all_passwords_disguises_codebooks
          else
            equipment = @@all_equipment
          end
          if (equipment - player_model.equipment).empty?
            do_nothing.(
              player_model: player_model,
              change_orders: change_orders,
              action_hash: action_hash
            )
          else
            buy_equipment.(
              change_orders: change_orders,
              purchase_options: equipment - player_model.equipment,
              purchase_limit: 1
            )
          end
        end
      end
    end
  end
end

