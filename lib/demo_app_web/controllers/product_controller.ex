defmodule DemoAppWeb.ProductController do
  use DemoAppWeb, :controller

  def index(conn, _params) do
    render(conn, :index, products: [])
  end
end