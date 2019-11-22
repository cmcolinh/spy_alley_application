# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class ConfiscateMaterials
      @@equipment = {
        'password' => 5,
        'disguise' => 5,
        'codebook' => 10,
        'key' => 25,
      }

      def call(player_model:, change_orders:, action_hash:, opponent_models:, decks_model: nil)
        opts = {}
        @@equipment.each do |equipment_type, cost|
          opts.merge!(
            add_equipment(
              target_player_model: target_player_model,
              player_model: player_model,
              cost: cost,
              equipment_type: equipment_type,
            )
          ){|k, v1, v2| v1 + v2}
        end
        opts.merge!(
          add_wild_cards(
            opponent_models: opponent_models,
            player_model: player_model
          )
        ){|k, v1, v2| v1 + v2}
        if opts.empty?
          false
        else
          change_orders.add_confiscate_materials_option(options: opts)
          true
        end
      end

      def add_equipment(player_model:, opponent_models:, equipment_type:, cost:)
        return {} if player_model.money < cost

        opponent_models.select do |opposing_player|
          opposing_player.equipment.any?{|equipment| equipment.include?(equipment_type)}
        end.map do |opposing_player|
          [
            "seat_#{opposing_player.seat}",
            opposing_player.equipment
              .select{|e| e.include?(equipment_type)}
              .reject{|e| player_model.equipment.include?(e)}
          ]
        end.to_h
      end

      def add_wild_cards(player_model:, opponent_models:)
        cost = 50
        return {} if player_model.money < cost

        opponent_models.select{|opposing_player| opposing_player.wild_cards > 0}.map do |opposing_player|
          ["seat_#{opposing_player.seat}", ['wild card']]
        end.to_h
      end
    end
  end
end
