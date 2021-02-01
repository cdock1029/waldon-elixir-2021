defmodule Waldon.Leases.Lease do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leases" do
    field :balance, :decimal
    field :deposit, :decimal
    field :end_time, :utc_datetime
    field :rent, :decimal
    field :start_time, :utc_datetime
    field :start_date, :date
    field :end_date, :date
    # field :unit_id, :id

    belongs_to :unit, Waldon.Properties.Unit

    many_to_many :tenants, Waldon.Tenants.Tenant, join_through: "tenant_leases"

    timestamps()
  end

  @doc false
  def changeset(lease, attrs) do
    lease
    |> cast(attrs, [:start_time, :end_time, :rent, :deposit])
    |> cast_assoc(:unit, required: true)
    |> validate_required([:start_time, :end_time, :rent, :deposit])
  end
end
