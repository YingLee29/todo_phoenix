
defmodule DemoAppWeb.StoreLive.FormComponent do
  use DemoAppWeb, :live_component

  alias DemoApp.Shop

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage store records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="store-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input
          field={@form[:user_id]}
          type="select"
          label="User"
          options={Enum.map(@users, &{&1.name, &1.id})}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Store</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{store: store} = assigns, socket) do
    users = DemoApp.Accounts.list_users()
    changeset = Shop.change_store(store)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:users, users)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"store" => store_params}, socket) do
    changeset = Shop.change_store(socket.assigns.store, store_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"store" => store_params}, socket) do
    save_store(socket, socket.assigns.action, store_params)
  end

  defp save_store(socket, :edit, store_params) do
    case Shop.update_store(socket.assigns.store, store_params) do
      {:ok, store} ->
        notify_parent({:saved, store})

        {:noreply,
         socket
         |> put_flash(:info, "Store updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_store(socket, :new, store_params) do
    case Shop.create_store(store_params) do
      {:ok, store} ->
        notify_parent({:saved, store})

        {:noreply,
         socket
         |> put_flash(:info, "Store created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
