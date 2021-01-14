defmodule Waldon.Repo.Migrations.CreateProperties do
  use Ecto.Migration

  def change do
    execute "create extension if not exists citext", "drop extension if exists citext"
    create table(:properties) do
      add :name, :citext, null: false
      add :address, :text

      timestamps()
    end

    create unique_index(:properties, [:name])
  end
end
