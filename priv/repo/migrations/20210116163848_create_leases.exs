defmodule Waldon.Repo.Migrations.CreateLeases do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS btree_gist", ""

    create table(:leases) do
      add :start_time, :timestamptz, null: false
      add :end_time, :timestamptz, null: false
      add :balance, :numeric, precision: 12, scale: 2, null: false, default: 0
      add :rent, :numeric, precision: 12, scale: 2, null: false
      add :deposit, :numeric, precision: 12, scale: 2, null: false, default: 0
      add :unit_id, references(:units, on_delete: :delete_all)

      timestamps()
    end

    create index(:leases, ["unit_id, start_time DESC"], name: "leases_unit_id_start_desc")
    create constraint(:leases, "rent_gt_0", check: "rent > 0")
    create constraint(:leases, "deposit_gte_0", check: "deposit >= 0")

    execute "alter table leases add column start_date date GENERATED ALWAYS as (date(start_time at time zone 'America/New_York')) STORED", ""
    execute "alter table leases add column end_date date GENERATED ALWAYS as (date(end_time at time zone 'America/New_York')) STORED", ""
    execute """
    alter table leases
    add constraint lease_unit_id_daterange_excl
    EXCLUDE USING GIST (
      unit_id with =,
      daterange(start_date, end_date) with &&
    )
    """, ""

    create constraint(:leases, "end_date_gt_start_date", check: "end_date > start_date")
  end
end
