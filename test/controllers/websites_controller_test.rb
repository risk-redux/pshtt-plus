require "test_helper"

class WebsitesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get websites_index_url
    assert_response :success
  end

  test "should get view" do
    get websites_view_url
    assert_response :success
  end
end
