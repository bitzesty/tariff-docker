class MeasurementUnit < Sequel::Model
  plugin :time_machine

  set_primary_key  :measurement_unit_code

  one_to_one :measurement_unit_description, key: :measurement_unit_code,
                                            primary_key: :measurement_unit_code

  delegate :description, to: :measurement_unit_description

  def to_s
    description
  end

  # has_many :measure_components, foreign_key: :measurement_unit_code
  # has_many :measurements, foreign_key: :measurement_unit_code
  # has_many :quota_definitions, foreign_key: :measurement_unit_code
  # has_many :measure_condition_components, foreign_key: :measurement_unit_code
  # has_many :measure_conditions, foreign_key: :condition_measurement_unit_code
  # has_one  :measurement_unit_description, foreign_key: :measurement_unit_code
end

