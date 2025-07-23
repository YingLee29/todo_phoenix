defmodule DemoAppWeb.StoreController do
  use DemoAppWeb, :controller

  def index(conn, _params) do
    render(conn, :index, stores: [])
  end
end