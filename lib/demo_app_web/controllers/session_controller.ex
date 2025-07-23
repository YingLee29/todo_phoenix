defmodule DemoAppWeb.SessionController do
  use DemoAppWeb, :controller

  alias DemoApp.Accounts

  def new(conn, _params) do
    render(conn, :new, layout: false)
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Đăng nhập thành công!")
        |> put_session(:user_id, user.id)
        |> redirect(to: ~p"/")

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Email hoặc mật khẩu không đúng")
        |> render(:new, layout: false)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Đăng xuất thành công!")
    |> clear_session()
    |> redirect(to: ~p"/")
  end
end