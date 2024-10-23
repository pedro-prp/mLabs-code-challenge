require "test_helper"

class ParkingTest < ActiveSupport::TestCase
  test "should not save parking without plate" do
    parking = Parking.new(paid:false)

    assert_not parking.save, "Saved the parking without a plate"
  end

  test "should save valid parking" do
    parking = Parking.new(plate: "TTT-5432", in_time: Time.now)

    puts parking

    assert_equal parking.save, true
  end

  test "calculate elapsed time should return correct minutes" do
    parking = Parking.new(in_time: Time.now - 90.minutes, plate: "TTT-7890")
    parking.save

    assert_equal 90, parking.calculate_elapsed_time(parking)

  end

  test "calculate payment price should return correct amount" do
    parking = Parking.new(in_time: Time.now - 90.minutes) # 90 minutes ago
    parking.save
    
    elapsed_time = parking.calculate_elapsed_time(parking)
    minute_rate = 0.30
    expected_price = elapsed_time * (minute_rate/2)

    assert_equal expected_price, parking.calculate_payment_price(elapsed_time, minute_rate)
  end
end
