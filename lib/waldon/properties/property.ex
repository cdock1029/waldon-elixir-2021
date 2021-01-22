defmodule Waldon.Properties.Property do
  use Ecto.Schema
  import Ecto.Changeset
  alias Waldon.Properties.Unit

  schema "properties" do
    field :address, :string
    field :name, :string

    has_many :units, Unit

    timestamps()
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:name, :address])
    # |> cast_assoc(:units, required: true)
    |> IO.inspect()
    |> update_change(:name, &String.trim/1)
    |> update_change(:address, &String.trim/1)
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
