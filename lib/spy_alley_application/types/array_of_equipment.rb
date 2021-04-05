# frozen_string_literal: true

require 'spy_alley_application/types/equipment'

SpyAlleyApplication::Types::ArrayOfEquipment =
  Types::Array::of(SpyAlleyApplication::Types::Equipment)

