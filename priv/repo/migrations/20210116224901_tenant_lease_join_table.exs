defmodule Waldon.Repo.Migrations.TenantLeaseJoinTable do
  use Ecto.Migration

  def change do

    create table("tenant_leases", primary_key: false) do
      add :tenant_id, references(:tenants)
      add :lease_id, references(:leases)
    end

  end

end
