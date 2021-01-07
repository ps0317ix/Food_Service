require 'test_helper'

class PlaceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get place_index_url
    assert_response :success
  end

end
