defmodule Waldon.Properties.Unit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "units" do
    field :name, :string
    # field :property_id, :id
    belongs_to :property, Waldon.Properties.Property

    timestamps()
  end

  @doc false
  def changeset(unit, attrs) do
    unit
    |> cast(attrs, [:name])
    |> update_change(:name, &String.trim/1)
    |> validate_required([:name])
    |> unique_constraint([:name, :property_id])
  end
end
