defmodule Waldon.LeasesTest do
  use Waldon.DataCase

  alias Waldon.Leases

  describe "leases" do
    alias Waldon.Leases.Lease

    @valid_attrs %{balance: "120.5", deposit: "120.5", end_time: "2010-04-17T14:00:00Z", rent: "120.5", start_time: "2010-04-17T14:00:00Z"}
    @update_attrs %{balance: "456.7", deposit: "456.7", end_time: "2011-05-18T15:01:01Z", rent: "456.7", start_time: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{balance: nil, deposit: nil, end_time: nil, rent: nil, start_time: nil}

    def lease_fixture(attrs \\ %{}) do
      {:ok, lease} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Leases.create_lease()

      lease
    end

    test "list_leases/0 returns all leases" do
      lease = lease_fixture()
      assert Leases.list_leases() == [lease]
    end

    test "get_lease!/1 returns the lease with given id" do
      lease = lease_fixture()
      assert Leases.get_lease!(lease.id) == lease
    end

    test "create_lease/1 with valid data creates a lease" do
      assert {:ok, %Lease{} = lease} = Leases.create_lease(@valid_attrs)
      assert lease.balance == Decimal.new("120.5")
      assert lease.deposit == Decimal.new("120.5")
      assert lease.end_time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert lease.rent == Decimal.new("120.5")
      assert lease.start_time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_lease/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Leases.create_lease(@invalid_attrs)
    end

    test "update_lease/2 with valid data updates the lease" do
      lease = lease_fixture()
      assert {:ok, %Lease{} = lease} = Leases.update_lease(lease, @update_attrs)
      assert lease.balance == Decimal.new("456.7")
      assert lease.deposit == Decimal.new("456.7")
      assert lease.end_time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert lease.rent == Decimal.new("456.7")
      assert lease.start_time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_lease/2 with invalid data returns error changeset" do
      lease = lease_fixture()
      assert {:error, %Ecto.Changeset{}} = Leases.update_lease(lease, @invalid_attrs)
      assert lease == Leases.get_lease!(lease.id)
    end

    test "delete_lease/1 deletes the lease" do
      lease = lease_fixture()
      assert {:ok, %Lease{}} = Leases.delete_lease(lease)
      assert_raise Ecto.NoResultsError, fn -> Leases.get_lease!(lease.id) end
    end

    test "change_lease/1 returns a lease changeset" do
      lease = lease_fixture()
      assert %Ecto.Changeset{} = Leases.change_lease(lease)
    end
  end
end
