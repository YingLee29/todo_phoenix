defmodule DemoAppWeb.ProductLive.Index do
  use DemoAppWeb, :live_view

  alias DemoApp.Shop
  alias DemoApp.Shop.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :products, Shop.list_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Shop.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({DemoAppWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Shop.get_product!(id)
    {:ok, _} = Shop.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end
end
