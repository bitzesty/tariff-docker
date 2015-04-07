require 'test_helper'

class BatchInvitationTest < ActiveSupport::TestCase
  setup do
    ActionMailer::Base.deliveries = []

    @app = create(:application)
    @bi = create(:batch_invitation, supported_permission_ids: [@app.signin_permission.id])
    @user_a = create(:batch_invitation_user, name: "A", email: "a@m.com", batch_invitation: @bi)
    @user_b = create(:batch_invitation_user, name: "B", email: "b@m.com", batch_invitation: @bi)
  end

  should "can belong to an organisation" do
    organisation = create(:organisation)
    bi = create(:batch_invitation, organisation: organisation)

    assert_equal bi.organisation, organisation
  end

  context "perform" do
    should "create the users and assign them permissions" do
      @bi.reload.perform

      user = User.find_by_email("a@m.com")
      assert_not_nil user
      assert_equal "A", user.name
      assert_equal ["signin"], user.permissions_for(@app)
    end

    should "trigger an invitation email" do
      @bi.perform

      email = ActionMailer::Base.deliveries.last
      assert_not_nil email
      assert_equal "Please confirm your account", email.subject
      assert_equal ["b@m.com"], email.to
    end

    should "record the outcome against the BatchInvitation" do
      @bi.perform
      assert_equal "success", @bi.outcome
    end

    context "one of the users already exists" do
      setup do
        @user = create(:user, name: "Arthur Dent", email: "a@m.com")
        @bi.perform
      end

      should "create the other users" do
        assert_not_nil User.find_by_email("b@m.com")
      end

      should "only send the invitation to the new user" do
        assert_equal 1, ActionMailer::Base.deliveries.size
      end

      should "skip that user entirely, including not altering permissions" do
        app = create(:application)
        another_app = create(:application)
        create(:supported_permission, application_id: another_app.id, name: "foo")
        @user.grant_application_permissions(another_app, ["signin", "foo"])

        @bi.supported_permission_ids = [another_app.signin_permission.id]
        @bi.save
        @bi.perform

        assert_empty @user.permissions_for(app)
        assert_same_elements ["signin", "foo"], @user.permissions_for(another_app)
      end
    end

    context "arbitrary error occurs" do
      should "mark it as failed and pass the error on for the worker to record the error details" do
        BatchInvitationUser.any_instance.expects(:invite).raises("ArbitraryError")

        assert_raises "ArbitraryError" do
          @bi.perform
        end
        assert_equal "fail", @bi.outcome
      end
    end

    context "one of the rows is missing a name or email" do
      setup do
        @user_a.update_column(:name, nil)
        @bi.perform
      end

      should "create the other users" do
        assert_nil User.find_by_email("a@m.com")
        assert_not_nil User.find_by_email("b@m.com")
      end
    end

    context "idempotence" do
      should "not re-invite users that have already been processed" do
        create(:user, :email => @user_a.email)
        @user_a.update_column(:outcome, "success")

        @bi.perform
        assert_equal 1, ActionMailer::Base.deliveries.size

        # Assert user_a status hasn't been set to skipped.
        @user_a.reload
        assert_equal "success", @user_a.outcome
      end
    end
  end
end
