defmodule WaldonWeb.TenantLiveTest do
  use WaldonWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Waldon.Tenants

  @create_attrs %{balance: "some balance", email: "some email", first_name: "some first_name", last_name: "some last_name", middle_name: "some middle_name", suffix: "some suffix"}
  @update_attrs %{balance: "some updated balance", email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", middle_name: "some updated middle_name", suffix: "some updated suffix"}
  @invalid_attrs %{balance: nil, email: nil, first_name: nil, last_name: nil, middle_name: nil, suffix: nil}

  defp fixture(:tenant) do
    {:ok, tenant} = Tenants.create_tenant(@create_attrs)
    tenant
  end

  defp create_tenant(_) do
    tenant = fixture(:tenant)
    %{tenant: tenant}
  end

  describe "Index" do
    setup [:create_tenant]

    test "lists all tenants", %{conn: conn, tenant: tenant} do
      {:ok, _index_live, html} = live(conn, Routes.tenant_index_path(conn, :index))

      assert html =~ "Listing Tenants"
      assert html =~ tenant.balance
    end

    test "saves new tenant", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.tenant_index_path(conn, :index))

      assert index_live |> element("a", "New Tenant") |> render_click() =~
               "New Tenant"

      assert_patch(index_live, Routes.tenant_index_path(conn, :new))

      assert index_live
             |> form("#tenant-form", tenant: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tenant-form", tenant: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tenant_index_path(conn, :index))

      assert html =~ "Tenant created successfully"
      assert html =~ "some balance"
    end

    test "updates tenant in listing", %{conn: conn, tenant: tenant} do
      {:ok, index_live, _html} = live(conn, Routes.tenant_index_path(conn, :index))

      assert index_live |> element("#tenant-#{tenant.id} a", "Edit") |> render_click() =~
               "Edit Tenant"

      assert_patch(index_live, Routes.tenant_index_path(conn, :edit, tenant))

      assert index_live
             |> form("#tenant-form", tenant: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tenant-form", tenant: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tenant_index_path(conn, :index))

      assert html =~ "Tenant updated successfully"
      assert html =~ "some updated balance"
    end

    test "deletes tenant in listing", %{conn: conn, tenant: tenant} do
      {:ok, index_live, _html} = live(conn, Routes.tenant_index_path(conn, :index))

      assert index_live |> element("#tenant-#{tenant.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tenant-#{tenant.id}")
    end
  end

  describe "Show" do
    setup [:create_tenant]

    test "displays tenant", %{conn: conn, tenant: tenant} do
      {:ok, _show_live, html} = live(conn, Routes.tenant_show_path(conn, :show, tenant))

      assert html =~ "Show Tenant"
      assert html =~ tenant.balance
    end

    test "updates tenant within modal", %{conn: conn, tenant: tenant} do
      {:ok, show_live, _html} = live(conn, Routes.tenant_show_path(conn, :show, tenant))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tenant"

      assert_patch(show_live, Routes.tenant_show_path(conn, :edit, tenant))

      assert show_live
             |> form("#tenant-form", tenant: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#tenant-form", tenant: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.tenant_show_path(conn, :show, tenant))

      assert html =~ "Tenant updated successfully"
      assert html =~ "some updated balance"
    end
  end
end
