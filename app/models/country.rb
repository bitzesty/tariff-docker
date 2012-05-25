class Country
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,     type: String
  field :iso_code, type: String

  has_and_belongs_to_many :country_groups
  has_many :measures, as: :region
  has_and_belongs_to_many :measure_exclusions, inverse_of: :excluded_countries,
                                               class_name: 'Measure'

  def to_s
    name
  end
end
