defmodule DemoAppWeb.RegistrationController do
  use DemoAppWeb, :controller

  alias DemoApp.Accounts
  alias DemoApp.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :new, changeset: changeset, layout: false)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Đăng ký thành công! Vui lòng đăng nhập.")
        |> redirect(to: ~p"/login")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, layout: false)
    end
  end
end