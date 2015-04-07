require 'test_helper'

class InactiveUsersSuspensionReminderMailingListTest < ActiveSupport::TestCase

  context "generating suspension mailing list" do
    setup do
      @in_1  = create(:user, current_sign_in_at: User::SUSPENSION_THRESHOLD_PERIOD.ago)
      @in_3  = create(:user, current_sign_in_at: (User::SUSPENSION_THRESHOLD_PERIOD - 2.days).ago)
      @in_7  = create(:user, current_sign_in_at: (User::SUSPENSION_THRESHOLD_PERIOD - 6.days).ago)
      @in_14 = create(:user, current_sign_in_at: (User::SUSPENSION_THRESHOLD_PERIOD - 13.days).ago)
    end

    def suspension_reminder_mailing_list
      InactiveUsersSuspensionReminderMailingList.new(User::SUSPENSION_THRESHOLD_PERIOD).generate
    end

    should "select users whose accounts will get suspended in 1 day" do
      assert_equal [@in_1], suspension_reminder_mailing_list[1]
    end

    should "select users whose accounts will get suspended in 3 days" do
      assert_equal [@in_3], suspension_reminder_mailing_list[3]
    end

    should "select users whose accounts will get suspended in 7 days" do
      assert_equal [@in_7], suspension_reminder_mailing_list[7]
    end

    should "select users whose accounts will get suspended in 14 days" do
      assert_equal [@in_14], suspension_reminder_mailing_list[14]
    end

    should "select users who signed-in more than suspension threshold days ago" do
      signed_in_48_days_ago = create(:user, current_sign_in_at: 48.days.ago)
      assert_include suspension_reminder_mailing_list[1], signed_in_48_days_ago
    end

    should "exclude recently unsuspended users from the mailings" do
      recently_unsuspended = create(:suspended_user, current_sign_in_at: 48.days.ago)
      Timecop.travel(2.days.ago) { recently_unsuspended.unsuspend }

      assert_not_include suspension_reminder_mailing_list[1], recently_unsuspended
    end
  end
end
