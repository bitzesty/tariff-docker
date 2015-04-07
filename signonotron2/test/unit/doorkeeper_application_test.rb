require 'test_helper'

class ::Doorkeeper::ApplicationTest < ActiveSupport::TestCase

  should "have a signin supported permission on create" do
    assert_not_nil create(:application).signin_permission
  end

  context "user_update_permission" do
    should "not be grantable from ui" do
      user_update_permission = create(:application, supports_push_updates: true).supported_permissions.detect {|perm| perm.name == 'user_update_permission' }
      assert_false user_update_permission.grantable_from_ui?
    end

    should "be created after save if application supports push updates" do
      application = create(:application, supports_push_updates: false)
      application.update_attributes(supports_push_updates: true)

      application.reload
      assert_include application.supported_permission_strings, 'user_update_permission'
    end

    should "not be created after save if application doesn't support push updates" do
      assert_not_include create(:application, supports_push_updates: false).supported_permission_strings, 'user_update_permission'
    end
  end

  context "supported_permission_strings" do

    should "return a list of string permissions" do
      user = create(:user)
      app = create(:application, with_supported_permissions: ["write"])

      assert_equal ["signin", "write"], app.supported_permission_strings(user)
    end

    should "only show permissions that organisation admins themselves have" do
      app = create(:application, with_delegatable_supported_permissions: ["write", "approve"])
      user = create(:organisation_admin, with_permissions: { app => ["write"] })

      assert_equal ["write"], app.supported_permission_strings(user)
    end

    should "only show delegatable permissions to organisation admins" do
      user = create(:organisation_admin)
      app = create(:application, with_delegatable_supported_permissions: ['write'], with_supported_permissions: ['approve'])
      user.grant_application_permissions(app, ['write', 'approve'])

      assert_equal ["write"], app.supported_permission_strings(user)
    end

  end

  context "scopes" do
    should "return applications that the user can signin into" do
      user = create(:user)
      application = create(:application)
      user.grant_application_permission(application, 'signin')

      assert_include Doorkeeper::Application.can_signin(user), application
    end

    should "not return applications that the user can't signin into" do
      user = create(:user)
      application = create(:application)

      assert_empty Doorkeeper::Application.can_signin(user)
    end

    should "return applications that support delegation of signin permission" do
      application = create(:application, with_delegatable_supported_permissions: ['signin'])

      assert_include Doorkeeper::Application.with_signin_delegatable, application
    end

    should "not return applications that don't support delegation of signin permission" do
      application = create(:application, with_supported_permissions: ['signin'])

      assert_empty Doorkeeper::Application.with_signin_delegatable
    end
  end
end
