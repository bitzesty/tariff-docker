class FootnoteType < Sequel::Model
  plugin :oplog, primary_key: :footnote_type_id

  set_primary_key [:footnote_type_id]

  one_to_many :footnotes
end

