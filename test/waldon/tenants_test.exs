defmodule Waldon.TenantsTest do
  use Waldon.DataCase

  alias Waldon.Tenants

  describe "tenants" do
    alias Waldon.Tenants.Tenant

    @valid_attrs %{balance: "some balance", email: "some email", first_name: "some first_name", last_name: "some last_name", middle_name: "some middle_name", suffix: "some suffix"}
    @update_attrs %{balance: "some updated balance", email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", middle_name: "some updated middle_name", suffix: "some updated suffix"}
    @invalid_attrs %{balance: nil, email: nil, first_name: nil, last_name: nil, middle_name: nil, suffix: nil}

    def tenant_fixture(attrs \\ %{}) do
      {:ok, tenant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tenants.create_tenant()

      tenant
    end

    test "list_tenants/0 returns all tenants" do
      tenant = tenant_fixture()
      assert Tenants.list_tenants() == [tenant]
    end

    test "get_tenant!/1 returns the tenant with given id" do
      tenant = tenant_fixture()
      assert Tenants.get_tenant!(tenant.id) == tenant
    end

    test "create_tenant/1 with valid data creates a tenant" do
      assert {:ok, %Tenant{} = tenant} = Tenants.create_tenant(@valid_attrs)
      assert tenant.balance == "some balance"
      assert tenant.email == "some email"
      assert tenant.first_name == "some first_name"
      assert tenant.last_name == "some last_name"
      assert tenant.middle_name == "some middle_name"
      assert tenant.suffix == "some suffix"
    end

    test "create_tenant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tenants.create_tenant(@invalid_attrs)
    end

    test "update_tenant/2 with valid data updates the tenant" do
      tenant = tenant_fixture()
      assert {:ok, %Tenant{} = tenant} = Tenants.update_tenant(tenant, @update_attrs)
      assert tenant.balance == "some updated balance"
      assert tenant.email == "some updated email"
      assert tenant.first_name == "some updated first_name"
      assert tenant.last_name == "some updated last_name"
      assert tenant.middle_name == "some updated middle_name"
      assert tenant.suffix == "some updated suffix"
    end

    test "update_tenant/2 with invalid data returns error changeset" do
      tenant = tenant_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenants.update_tenant(tenant, @invalid_attrs)
      assert tenant == Tenants.get_tenant!(tenant.id)
    end

    test "delete_tenant/1 deletes the tenant" do
      tenant = tenant_fixture()
      assert {:ok, %Tenant{}} = Tenants.delete_tenant(tenant)
      assert_raise Ecto.NoResultsError, fn -> Tenants.get_tenant!(tenant.id) end
    end

    test "change_tenant/1 returns a tenant changeset" do
      tenant = tenant_fixture()
      assert %Ecto.Changeset{} = Tenants.change_tenant(tenant)
    end
  end
end
