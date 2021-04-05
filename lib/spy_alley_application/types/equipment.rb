# frozen string_literal: true

require 'dry-types'
require 'spy_alley_application/models/equipment'
require 'spy_alley_application/types/equipment_type'
require 'spy_alley_application/types/nationality'

get_equipment = Hash.new do |h, k|
  nationality, type = k.split(' ')
  h[k] = SpyAlleyApplication::Models::Equipment::new(nationality: nationality, type: type)
end

i = Class.new do
  def initialize(get_equipment)
    @get_equipment = get_equipment
  end

  def call(equipment)
    if !equipment.to_s.count(' ').eql?(1) || !equipment.to_s.split(' ').count.eql?(2)
      raise Dry::Types::ConstraintError::new(
        'Equipment string is ill formed', equipment.to_s)
    end
    nationality, type = equipment.to_s.split(' ')
    SpyAlleyApplication::Types::Nationality.call(nationality)
    SpyAlleyApplication::Types::EquipmentType.call(type)
    @get_equipment[equipment.to_s]
  end
end.new(get_equipment)

SpyAlleyApplication::Types::Equipment =
  Types::Constructor(SpyAlleyApplication::Models::Equipment){|value| i.call(value)}

