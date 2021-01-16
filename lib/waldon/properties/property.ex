defmodule Waldon.Properties.Property do
  use Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :address, :string
    field :name, :string

    has_many :units, Waldon.Properties.Unit

    timestamps()
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:name, :address])
    |> cast_assoc(:units, required: true)
    |> update_change(:name, &String.trim/1)
    |> update_change(:address, &String.trim/1)
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
