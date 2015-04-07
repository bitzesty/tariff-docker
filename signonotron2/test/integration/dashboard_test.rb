#encoding: utf-8
require 'test_helper'

class DashboardTest < ActionDispatch::IntegrationTest
  should "notify the user if they've not been assigned any applications" do
    user = create(:user)
    visit root_path
    signin(user)

    assert_response_contains("Your Applications")
    assert_response_contains("You haven’t been assigned to any applications yet")
  end

  should "show the user's assigned applications" do
    app = create(:application, name: "MyApp")
    user = create(:user, with_signin_permissions_for: [ app ] )

    visit root_path
    signin(user)

    assert_response_contains(app.description)
    assert page.has_css?("a[href='#{app.home_uri}']")
  end
end
