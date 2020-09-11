defmodule GeoTrackerWeb.Plugs.VerifyApiKey do
  @moduledoc """
  Plug for verifying API key from request headers.
  """
  import Plug.Conn

  alias GeoTracker.Users
  alias GeoTracker.Users.User

  @header_token "x-api-key"

  def init(opts), do: opts

  def call(conn, user_role: role) do
    conn
    |> token_from_header()
    |> verify(role)
  end

  defp token_from_header(conn) do
    token =
      conn
      |> get_req_header(@header_token)
      |> Enum.at(0, "")

    {conn, token}
  end

  defp verify({conn, ""}, _role),
    do: forbid(conn, :api_key, "api_key_missing")

  defp verify({conn, token}, role) do
    token
    |> Users.get_user(role)
    |> verification_result(conn)
  end

  defp verification_result(%User{} = user, conn),
    do: assign(conn, :user, user)

  defp verification_result(nil, conn),
    do: forbid(conn, :api_key, "not_permitted")

  def forbid(conn, field, error) do
    error = encoded_error(field, error)

    conn
    |> put_resp_content_type("application/json")
    |> resp(:unauthorized, error)
    |> halt()
  end

  defp encoded_error(field, error),
    do: Jason.encode!(%{errors: %{field => [error]}})
end
