class QuotaBalanceEvent < Sequel::Model
  set_primary_key  [:quota_definition_sid, :occurrence_timestamp]

  many_to_one :quota_definition, key: :quota_definition_sid,
                                 primary_key: :quota_definition_sid

  dataset_module do
    def last
      order(:occurrence_timestamp.desc).first
    end
  end

  def self.status
    'open'
  end
end

