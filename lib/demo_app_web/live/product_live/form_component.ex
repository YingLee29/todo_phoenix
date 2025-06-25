defmodule DemoAppWeb.ProductLive.FormComponent do
  use DemoAppWeb, :live_component

  alias DemoApp.Shop

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Nam" />
        <.input field={@form[:price]} type="number" label="Price" />
        <.input
          field={@form[:user_id]}
          type="select"
          label="User Management"
          options={Enum.map(@users, &{&1.name, &1.id})}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    users = DemoApp.Accounts.list_users()
    changeset = Shop.change_product(product)

    {:ok,
    socket
    |> assign(assigns)
    |> assign(:users, users)
    |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset = Shop.change_product(socket.assigns.product, product_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    case Shop.update_product(socket.assigns.product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Shop.create_product(product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
