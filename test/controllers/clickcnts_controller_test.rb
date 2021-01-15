require 'test_helper'

class ClickcntsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get clickcnts_index_url
    assert_response :success
  end

  test "should get show" do
    get clickcnts_show_url
    assert_response :success
  end

end
