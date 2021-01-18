defmodule Waldon.Properties.Unit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "units" do
    field :name, :string, default: ""
    # field :property_id, :id
    belongs_to :property, Waldon.Properties.Property

    has_many :leases, Waldon.Leases.Lease

    timestamps()
  end

  @doc false
  def changeset(unit, attrs) do
    unit
    |> cast(attrs, [:name])
    |> update_change(:name, &String.trim/1)
    |> validate_required([:name])
    |> unique_constraint(:name, name: :units_property_id_name_index)
  end
end
