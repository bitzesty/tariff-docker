class Rollback
  include Her::Model

  attributes :id, :enqueued_at, :keep, :date, :user_id, :reason

  collection_path '/rollbacks'

  include_root_in_json true

  def enqueued_at
    Time.parse(super) if super.present?
  end

  def user=(user)
    self.user_id = user.id
  end

  def user
    @user ||= User.find(id: user_id)
  end

  def initialize_errors
    response_errors.each do |attribute, error_messages|
      Array(error_messages).each do |error_message|
        errors.add(attribute, error_message)
      end
    end
  end
end
