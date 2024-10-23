require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without username" do
    user = User.new(password: "testpass")
    
    assert_not user.save, "Saved the user without a username"
  end

  test "should save valid user" do
    user = User.new(username: "test-user-model", password: "testpass")
    
    assert_equal user.save, true
  end
end
