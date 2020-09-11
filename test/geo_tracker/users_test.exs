defmodule GeoTracker.UsersTest do
  use GeoTracker.DataCase

  alias GeoTracker.Factory
  alias GeoTracker.Users

  setup do
    driver = Factory.insert(:driver)
    manager = Factory.insert(:manager)

    [driver: driver, manager: manager]
  end

  describe "&get_user/2" do
    test "it returns user by api key and role", %{driver: driver, manager: manager} do
      assert driver == Users.get_user(driver.api_key, driver.role)
      assert manager == Users.get_user(manager.api_key, manager.role)
    end
  end
end
