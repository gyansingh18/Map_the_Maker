require "test_helper"

class KarmaControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get karma_dashboard_url
    assert_response :success
  end
end
