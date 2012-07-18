class FootnoteDescriptionPeriod < Sequel::Model
  plugin :time_machine

  set_primary_key :footnote_id, :footnote_type_id, :footnote_description_period_sid

  one_to_one :footnote_description, key: [:footnote_id, :footnote_type_id,
                                          :footnote_description_period_sid]

  # belongs_to :footnote_type
  # belongs_to :footnote, foreign_key: [:footnote_id, :footnote_type_id]
  # belongs_to :footnote_description, foreign_key: [:footnote_id,
  #                                                 :footnote_type_id,
  #                                                 :footnote_description_period_sid]
end

# == Schema Information
#
# Table name: footnote_description_periods
#
#  record_code                     :string(255)
#  subrecord_code                  :string(255)
#  record_sequence_number          :string(255)
#  footnote_description_period_sid :string(255)     primary key
#  footnote_type_id                :string(255)
#  footnote_id                     :string(255)
#  validity_start_date             :date
#  created_at                      :datetime
#  updated_at                      :datetime
#

