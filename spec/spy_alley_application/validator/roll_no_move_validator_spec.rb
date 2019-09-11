# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Validator::RollNoMoveCardValidator do
  let(:validator){
    SpyAlleyApplication::Validator::RollNoMoveCardValidator::new(
      roll_options:         nil,
      accusation_targets:   ['seat_2', 'seat_3'],
      accusable_identities: %w(french german spanish italian american russian)
    )
  }
end
