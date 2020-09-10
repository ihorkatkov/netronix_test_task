# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GeoTracker.Repo.insert!(%GeoTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

generate_user = fn _ ->
  %GeoTracker.Users.User{api_key: UUID.uuid4(), role: Enum.random(["driver", "manager"])}
  |> GeoTracker.Repo.insert!()
end

Enum.each(0..100, generate_user)
