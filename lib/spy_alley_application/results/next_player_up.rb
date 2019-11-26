# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class NextPlayerUp
      def call(options = {})
        player_model, opponent_models, action_hash, turn_not_complete = get_vars_from(options)
        change_orders.add_next_player_up(
          seat: turn_not_complete ? player_model.seat, get_next_seat_from(player_model, opponent_models)
        )
      end

      private
      def get_next_seat_from(player_model, opponent_models)
        opponent_seats = opponent_models.map(&:seat)
        opponent_seats.select{|seat| seat > player_model.seat}.min || opponent_seats.min
      end

      def get_vars_from(options)
        errors = [:player_model, :opponent_models, :action_hash, :turn_not_complete?].select do |key|
          !options.has_key(key)
        end.map{|key| "missing keyword argument #{key}"}.join("\r\n")
        raise errors unless errors.empty?

        [
          options[:player_model],
          options[:opponent_models],
          options[:action_hash],
          options[:turn_not_complete?]
        ]
      end
    end
  end
end
