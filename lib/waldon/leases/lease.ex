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
    field :unit_id, :id

    timestamps()
  end

  @doc false
  def changeset(lease, attrs) do
    lease
    |> cast(attrs, [:start_time, :end_time, :balance, :rent, :deposit])
    |> validate_required([:start_time, :end_time, :balance, :rent, :deposit])
  end
end
