defmodule DemoAppWeb.UserController do
  use DemoAppWeb, :controller

  alias DemoApp.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end
end