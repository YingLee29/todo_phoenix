defmodule DemoApp.Shop.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :price, :integer

    belongs_to :user, DemoApp.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :price])
    |> validate_required([:name, :price])
  end
end
