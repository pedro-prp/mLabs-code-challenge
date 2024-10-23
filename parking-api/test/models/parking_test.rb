require "test_helper"

class ParkingTest < ActiveSupport::TestCase
  test "should not save user without username" do
    user = User.new(password: "testpass")
    
    assert_not user.save, "Saved the user without a username"
  end

  test "should save valid user" do
    user = User.new(username: "testuser", password: "testpass")
    
    assert user.save, "Could not save a valid user"
  end
end
