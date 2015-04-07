module Devise
  module Models

    module Suspendable
      extend ActiveSupport::Concern

      included do
        scope :active, where('suspended_at' => nil)
        scope :suspended, where('suspended_at IS NOT NULL')
        scope :current, proc { |current| current == 't' ? active : suspended }
      end

      def active_for_authentication?
        if super
          return true unless suspended?
          EventLog.record_event(self, EventLog::SUSPENDED_ACCOUNT_AUTHENTICATED_LOGIN)
        end
        false
      end

      def inactive_message
        suspended? ? :suspended : super
      end

      # Suspends the user in the database.
      def suspend(reason)
        self.reason_for_suspension = reason
        self.suspended_at = Time.zone.now
        Statsd.new(::STATSD_HOST).increment("#{::STATSD_PREFIX}.users.suspend")
        save
      end

      # un-suspends the user in the database.
      def unsuspend
        self.reason_for_suspension = nil
        self.suspended_at = nil
        self.unsuspended_at = Time.zone.now
        save
      end

      def suspended?
        suspended_at.present?
      end
    end
  end
end
