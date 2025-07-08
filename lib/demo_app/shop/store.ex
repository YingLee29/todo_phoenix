
defmodule DemoApp.Shop.Store do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stores" do
    field :name, :string
    belongs_to :user, DemoApp.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
