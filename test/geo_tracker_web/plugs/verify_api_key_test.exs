defmodule GeoTrackerWeb.Plugs.VerifyApiKeyTest do
  use GeoTrackerWeb.ConnCase

  alias GeoTracker.Factory
  alias GeoTrackerWeb.Plugs.VerifyApiKey

  setup do
    driver = Factory.insert(:driver)
    manager = Factory.insert(:manager)

    [driver: driver, manager: manager]
  end

  describe "&call/2" do
    test "it should return forbidden when there is no api key in headers", %{conn: conn} do
      response_conn = VerifyApiKey.call(conn, user_role: "manager")

      assert json_response(response_conn, 401) == %{
               "errors" => %{"api_key" => ["api_key_missing"]}
             }
    end

    test "it should return forbidden when user doesn't belongs to a given role", %{
      conn: conn,
      driver: driver
    } do
      response_conn =
        conn
        |> put_req_header("x-api-key", driver.api_key)
        |> VerifyApiKey.call(user_role: "manager")

      assert json_response(response_conn, 401) == %{
               "errors" => %{"api_key" => ["not_permitted"]}
             }
    end

    test "it should assign a user to conn", %{conn: conn, driver: driver} do
      assert %{assigns: %{user: ^driver}} =
               conn
               |> put_req_header("x-api-key", driver.api_key)
               |> VerifyApiKey.call(user_role: "driver")
    end
  end
end
