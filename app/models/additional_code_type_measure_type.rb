class AdditionalCodeTypeMeasureType < Sequel::Model
  set_primary_key [:measure_type_id, :additional_code_type_id]

  many_to_one :measure_type
  many_to_one :additional_code_type
end

