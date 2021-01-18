defmodule Waldon.Leases do
  @moduledoc """
  The Leases context.
  """

  import Ecto.Query, warn: false
  alias Waldon.Repo

  alias Waldon.Leases.Lease

  @doc """
  Returns the list of leases.

  ## Examples

      iex> list_leases()
      [%Lease{}, ...]

  """
  def list_leases do
    Repo.all(
      from lease in Lease,
        inner_join: unit in assoc(lease, :unit),
        inner_join: property in assoc(unit, :property),
        order_by: [property.id, unit.id, desc: :start_time],
        preload: [unit: {unit, property: property}]
    )
  end

  @doc """
  Gets a single lease.

  Raises `Ecto.NoResultsError` if the Lease does not exist.

  ## Examples

      iex> get_lease!(123)
      %Lease{}

      iex> get_lease!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lease!(id) do
    Repo.one(
      from l in Lease,
        where: l.id == ^id,
        inner_join: u in assoc(l, :unit),
        inner_join: p in assoc(u, :property),
        preload: [unit: {u, property: p}]
    )
  end

  @doc """
  Creates a lease.

  ## Examples

      iex> create_lease(%{field: value})
      {:ok, %Lease{}}

      iex> create_lease(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lease(attrs \\ %{}) do
    %Lease{}
    |> Lease.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lease.

  ## Examples

      iex> update_lease(lease, %{field: new_value})
      {:ok, %Lease{}}

      iex> update_lease(lease, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lease(%Lease{} = lease, attrs) do
    lease
    |> Lease.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lease.

  ## Examples

      iex> delete_lease(lease)
      {:ok, %Lease{}}

      iex> delete_lease(lease)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lease(%Lease{} = lease) do
    Repo.delete(lease)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lease changes.

  ## Examples

      iex> change_lease(lease)
      %Ecto.Changeset{data: %Lease{}}

  """
  def change_lease(%Lease{} = lease, attrs \\ %{}) do
    Lease.changeset(lease, attrs)
  end
end
