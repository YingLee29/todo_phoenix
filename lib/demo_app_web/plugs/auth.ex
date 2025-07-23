defmodule DemoAppWeb.Plugs.Auth do
  @moduledoc """
  Authentication plug for handling user sessions.
  """
  import Plug.Conn
  import Phoenix.Controller

  alias DemoApp.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      user_id ->
        try do
          user = Accounts.get_user!(user_id)
          assign(conn, :current_user, user)
        rescue
          Ecto.NoResultsError ->
            conn
            |> clear_session()
            |> assign(:current_user, nil)
        end

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "Bạn cần đăng nhập để truy cập trang này.")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def require_unauthenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: "/")
      |> halt()
    else
      conn
    end
  end
end