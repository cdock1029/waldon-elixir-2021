defmodule Waldon.Repo.Migrations.CreateUnits do
  use Ecto.Migration

  def change do
    create table(:units) do
      add :name, :citext
      add :property_id, references(:properties, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:units, [:property_id, :name])
    # create index(:units, [:property_id])
  end
end
