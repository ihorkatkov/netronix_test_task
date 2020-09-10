defmodule GeoTrackerWeb.TaskControllerTest do
  use GeoTrackerWeb.ConnCase

  alias GeoTracker.Factory

  @create_attrs %{
    pickup_location: %{lat: 1.0, long: 1.0},
    dropoff_location: %{lat: 1.1, long: 1.1}
  }

  setup %{conn: conn} do
    driver = Factory.insert(:driver)
    manager = Factory.insert(:manager)

    {:ok,
     conn: put_req_header(conn, "accept", "application/json"), driver: driver, manager: manager}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, Routes.task_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create" do
    test "returns forbidden when the user isn't authorized", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), @create_attrs)

      assert json_response(conn, 401) == %{"errors" => %{"api_key" => ["api_key_missing"]}}
    end

    test "returns forbidden when the user isn't a manager", %{conn: conn, driver: driver} do
      conn =
        conn
        |> put_req_header("x-api-key", driver.api_key)
        |> post(Routes.task_path(conn, :create), @create_attrs)

      assert json_response(conn, 401) == %{"errors" => %{"api_key" => ["not_permitted"]}}
    end

    test "returns created task", %{conn: conn, manager: manager} do
      conn =
        conn
        |> put_req_header("x-api-key", manager.api_key)
        |> post(Routes.task_path(conn, :create), @create_attrs)

      assert %{
               "dropoff_location" => %{"lat" => 1.1, "long" => 1.1},
               "pickup_location" => %{"lat" => 1.0, "long" => 1.0},
               "status" => "new"
             } = json_response(conn, 200)
    end
  end
end
