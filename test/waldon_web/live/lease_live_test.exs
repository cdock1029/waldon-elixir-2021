defmodule WaldonWeb.LeaseLiveTest do
  use WaldonWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Waldon.Leases

  @create_attrs %{balance: "120.5", deposit: "120.5", end_time: "2010-04-17T14:00:00Z", rent: "120.5", start_time: "2010-04-17T14:00:00Z"}
  @update_attrs %{balance: "456.7", deposit: "456.7", end_time: "2011-05-18T15:01:01Z", rent: "456.7", start_time: "2011-05-18T15:01:01Z"}
  @invalid_attrs %{balance: nil, deposit: nil, end_time: nil, rent: nil, start_time: nil}

  defp fixture(:lease) do
    {:ok, lease} = Leases.create_lease(@create_attrs)
    lease
  end

  defp create_lease(_) do
    lease = fixture(:lease)
    %{lease: lease}
  end

  describe "Index" do
    setup [:create_lease]

    test "lists all leases", %{conn: conn, lease: lease} do
      {:ok, _index_live, html} = live(conn, Routes.lease_index_path(conn, :index))

      assert html =~ "Listing Leases"
    end

    test "saves new lease", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.lease_index_path(conn, :index))

      assert index_live |> element("a", "New Lease") |> render_click() =~
               "New Lease"

      assert_patch(index_live, Routes.lease_index_path(conn, :new))

      assert index_live
             |> form("#lease-form", lease: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#lease-form", lease: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.lease_index_path(conn, :index))

      assert html =~ "Lease created successfully"
    end

    test "updates lease in listing", %{conn: conn, lease: lease} do
      {:ok, index_live, _html} = live(conn, Routes.lease_index_path(conn, :index))

      assert index_live |> element("#lease-#{lease.id} a", "Edit") |> render_click() =~
               "Edit Lease"

      assert_patch(index_live, Routes.lease_index_path(conn, :edit, lease))

      assert index_live
             |> form("#lease-form", lease: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#lease-form", lease: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.lease_index_path(conn, :index))

      assert html =~ "Lease updated successfully"
    end

    test "deletes lease in listing", %{conn: conn, lease: lease} do
      {:ok, index_live, _html} = live(conn, Routes.lease_index_path(conn, :index))

      assert index_live |> element("#lease-#{lease.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#lease-#{lease.id}")
    end
  end

  describe "Show" do
    setup [:create_lease]

    test "displays lease", %{conn: conn, lease: lease} do
      {:ok, _show_live, html} = live(conn, Routes.lease_show_path(conn, :show, lease))

      assert html =~ "Show Lease"
    end

    test "updates lease within modal", %{conn: conn, lease: lease} do
      {:ok, show_live, _html} = live(conn, Routes.lease_show_path(conn, :show, lease))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Lease"

      assert_patch(show_live, Routes.lease_show_path(conn, :edit, lease))

      assert show_live
             |> form("#lease-form", lease: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#lease-form", lease: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.lease_show_path(conn, :show, lease))

      assert html =~ "Lease updated successfully"
    end
  end
end
