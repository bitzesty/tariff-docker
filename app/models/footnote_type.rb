class FootnoteType < Sequel::Model
  # set_primary_key  :footnote_type_id
 
  # has_many :footnotes, foreign_key: :footnote_type_id
  # has_many :footnote_description, foreign_key: :footnote_type_id
  # has_many :footnote_description_periods, foreign_key: :footnote_type_id
  # has_one  :footnote_type_description, foreign_key: :footnote_type_id

  APPLICATION_CODES = {
    1 => "CN nomencalture",
    2 => "TARIC nomencalture",
    3 => "Export refund nomencalture",
    5 => "Additional codes",
    6 => "CN Measures",
    7 => "Other Measures",
    8 => "Measuring Heading",
  }
end
