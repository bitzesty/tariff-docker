class UserApplicationPermission < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :user
  belongs_to :application, class_name: 'Doorkeeper::Application'
  belongs_to :supported_permission

  validates_presence_of :user_id, :supported_permission_id, :application_id
  validates_uniqueness_of :supported_permission_id, scope: [:user_id, :application_id]

  before_validation :assign_application_id

  private

  # application_id is duplicated across supported_permissions and user_application_permissions
  # to efficiently address common queries for a user's permissions for a particular application
  def assign_application_id
    self.application_id = supported_permission.application_id if supported_permission.present?
  end
end
