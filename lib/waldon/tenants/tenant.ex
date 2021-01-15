defmodule Waldon.Tenants.Tenant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenants" do
    field :balance, :decimal
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :suffix, :string
    field :full_name, :string

    timestamps()
  end

  @doc false
  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:first_name, :middle_name, :last_name, :suffix, :balance, :email])
    |> update_change(:first_name, &String.trim/1)
    |> update_change(:middle_name, &String.trim/1)
    |> update_change(:last_name, &String.trim/1)
    |> update_change(:suffix, &String.trim/1)
    |> update_change(:email, &String.trim/1)
    |> validate_required([:first_name, :last_name])
    |> unique_constraint(:first_name, name: :tenants_full_name_index)
    |> unique_constraint(:email)
  end
end
