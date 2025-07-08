
defmodule DemoAppWeb.StoreLive.Index do
  use DemoAppWeb, :live_view

  alias DemoApp.Shop
  alias DemoApp.Shop.Store

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :stores, Shop.list_stores())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Store")
    |> assign(:store, Shop.get_store!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Store")
    |> assign(:store, %Store{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Stores")
    |> assign(:store, nil)
  end

  @impl true
  def handle_info({DemoAppWeb.StoreLive.FormComponent, {:saved, store}}, socket) do
    {:noreply, stream_insert(socket, :stores, store)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    store = Shop.get_store!(id)
    {:ok, _} = Shop.delete_store(store)

    {:noreply, stream_delete(socket, :stores, store)}
  end
end
