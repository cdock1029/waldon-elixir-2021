defmodule WaldonWeb.TenantLive.Index do
  use WaldonWeb, :live_view

  alias Waldon.Tenants
  alias Waldon.Tenants.Tenant

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tenants, list_tenants())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tenant")
    |> assign(:tenant, Tenants.get_tenant!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tenant")
    |> assign(:tenant, %Tenant{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tenants")
    |> assign(:tenant, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tenant = Tenants.get_tenant!(id)
    {:ok, _} = Tenants.delete_tenant(tenant)

    {:noreply, assign(socket, :tenants, list_tenants())}
  end

  defp list_tenants do
    Tenants.list_tenants()
  end
end
