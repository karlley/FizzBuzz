require 'test_helper'

class ValuesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get values_new_url
    assert_response :success
  end

  test "should get show" do
    get values_show_url
    assert_response :success
  end

  test "should get index" do
    get values_index_url
    assert_response :success
  end

end
