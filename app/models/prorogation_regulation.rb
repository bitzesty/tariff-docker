class ProrogationRegulation < Sequel::Model
  plugin :oplog, primary_key: [:prorogation_regulation_id,
                               :prorogation_regulation_role]
  set_primary_key [:prorogation_regulation_id, :prorogation_regulation_role]
end


