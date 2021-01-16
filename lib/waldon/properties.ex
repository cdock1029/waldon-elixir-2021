defmodule Waldon.Properties do
  import Ecto.Query, warn: false
  alias Waldon.Repo

  alias Waldon.Properties.Property
  alias Waldon.Properties.Unit

  def list_properties do
    Repo.all(from p in Property, order_by: p.name)
  end

  def get_property!(id) do
    units_query = from u in Unit, order_by: u.name

    [property] =
      Repo.all(
        from p in Property,
          where: p.id == ^id,
          preload: [units: ^units_query]
      )

    property
  end

  def get_unit!(id) do
    Repo.get!(Unit, id)
  end

  def create_property(attrs \\ %{}) do
    %Property{}
    |> Property.changeset(attrs)
    |> Repo.insert()
  end

  def create_unit(%Property{} = property, attrs \\ %{}) do
    %Unit{}
    |> Unit.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:property, property)
    |> Repo.insert()
  end

  def update_property(%Property{} = property, attrs) do
    property
    |> Property.changeset(attrs)
    |> Repo.update()
  end

  def update_unit(%Unit{} = unit, attrs) do
    unit
    |> Unit.changeset(attrs)
    |> Repo.update()
  end

  def delete_property(%Property{} = property) do
    Repo.delete(property)
  end

  def delete_unit(%Unit{} = unit) do
    Repo.delete(unit)
  end

  def change_property(%Property{} = property, attrs \\ %{}) do
    Property.changeset(property, attrs)
  end

  def change_unit(%Unit{} = unit, attrs \\ %{}) do
    Unit.changeset(unit, attrs)
  end
end
