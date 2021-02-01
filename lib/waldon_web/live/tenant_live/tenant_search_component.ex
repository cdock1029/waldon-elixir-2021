defmodule WaldonWeb.TenantLive.TenantSearchComponent do
  use WaldonWeb, :live_component

  alias Waldon.Tenants

  @impl true
  def mount(socket) do
    {:ok, assign(socket, query: "", results: [])}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, assign(socket, results: search(query))}
  end

  def handle_event("select", %{"tenant" => tenant}, socket) do
    send_update(WaldonWeb.LeaseLive.FormComponent, id: :new, tenant_selected: tenant)

    {:noreply, socket}
  end

  defp search(query) do
    Tenants.search_tenants_full_name(query)
  end
end
