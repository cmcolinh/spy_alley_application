# frozen_string_literal: true

module SpyAlleyApplication
  module Types
  end
end

SpyAlleyApplication::Types::EquipmentType =
  ::Types::String::enum('password', 'disguise', 'codebook', 'key')
