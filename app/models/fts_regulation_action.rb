class FtsRegulationAction < Sequel::Model
  set_primary_key [:fts_regulation_id, :fts_regulation_role,
                   :stopped_regulation_id, :stopped_regulation_role]

  # belongs_to :fts_regulation, foreign_key: [:fts_regulation_id, :fts_regulation_role],
  #                             class_name: 'FullTemporaryStopRegulation'
  # belongs_to :stopped_fts_regulation, foreign_key: [:stopped_regulation_id, :stopped_regulation_role],
  #                                     class_name: 'FullTemporaryStopRegulation'
  # belongs_to :fts_regulation_role_type, foreign_key: :fts_regulation_role,
  #                                       class_name: 'RegulationRoleType'
  # belongs_to :stopped_regulation_role_type, foreign_key: :stopped_regulation_role,
  #                                       class_name: 'RegulationRoleType'
end

