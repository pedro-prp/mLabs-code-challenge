require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "Should create a user" do
    post register_url, headers:
  end
end
