defmodule GeoTracker.TasksTest do
  use GeoTracker.DataCase

  alias GeoTracker.Factory
  alias GeoTracker.Tasks

  describe "tasks" do
    alias GeoTracker.Tasks.Task

    @valid_attrs %{
      dropoff_location: %Geo.Point{coordinates: {1.0, 1.0}},
      pickup_location: %Geo.Point{coordinates: {1.1, 1.1}},
      status: "new"
    }
    @update_attrs %{
      dropoff_location: %Geo.Point{coordinates: {1.05, 1.05}},
      pickup_location: %Geo.Point{coordinates: {1.15, 1.15}},
      status: "assigned"
    }
    @invalid_attrs %{dropoff_location: nil, pickup_location: nil, status: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tasks.create_task()

      task
    end

    test "list_nearest_tasks/2 returns all nearest tasks by given point and status" do
      third_task = Factory.insert(:task, pickup_location: %Geo.Point{coordinates: {3.0, 3.0}})
      second_task = Factory.insert(:task, pickup_location: %Geo.Point{coordinates: {2.0, 2.0}})
      first_task = Factory.insert(:task)
      Factory.insert(:task, status: "assigned")

      assert [first_task, second_task, third_task] ==
               Tasks.list_nearest_tasks(%Geo.Point{coordinates: {1.0, 1.0}}, "new")
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Tasks.create_task(@valid_attrs)

      assert task.dropoff_location == %Geo.Point{coordinates: {1.0, 1.0}}
      assert task.pickup_location == %Geo.Point{coordinates: {1.1, 1.1}}
      assert task.status == "new"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Tasks.update_task(task, @update_attrs)
      assert task.dropoff_location == %Geo.Point{coordinates: {1.05, 1.05}}
      assert task.pickup_location == %Geo.Point{coordinates: {1.15, 1.15}}
      assert task.status == "assigned"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task(task.id)
    end

    test "update_task/2 returns an error when status change is not permitted" do
      task = task_fixture()
      params = @valid_attrs |> Map.put(:status, "done")

      assert {:error, %Ecto.Changeset{errors: [status: {status_error, _rest}]}} =
               Tasks.update_task(task, params)

      assert status_error =~ "not permitted status change. Valid values are"
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      refute Tasks.get_task(task.id)
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
