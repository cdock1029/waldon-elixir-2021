defmodule Waldon.Repo.Migrations.CreateTenants do
  use Ecto.Migration

  def change do
    execute "CREATE OR REPLACE FUNCTION immutable_concat_ws(text, VARIADIC text[])
    RETURNS text AS 'text_concat_ws' LANGUAGE internal IMMUTABLE PARALLEL SAFE",
    "DROP FUNCTION if exists immutable_concat_ws"

    create table(:tenants) do
      add :first_name, :citext, null: false
      add :middle_name, :citext
      add :last_name, :citext, null: false
      add :suffix, :citext
      add :balance, :numeric, precision: 12, scale: 2, default: 0
      add :email, :citext

      timestamps()
    end

    execute """
    alter table tenants
    add full_name citext generated always as (immutable_concat_ws(' ',first_name,middle_name,last_name,suffix)) STORED
    """, ""

    create unique_index(:tenants, [:full_name])
  end
end
