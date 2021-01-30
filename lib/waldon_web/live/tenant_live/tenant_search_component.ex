defmodule WaldonWeb.TenantLive.TenantSearchComponent do
  use WaldonWeb, :live_component

  alias Waldon.Tenants

  def mount(socket) do
    socket = assign(socket, query: "", results: [])
    {:ok, socket}
  end

  def handle_event("suggest", %{"q" => query}, socket) do
    socket = assign(socket, results: search(query), query: query)
    {:noreply, socket}
  end

  def handle_event("select", param, socket) do
    IO.inspect(param)

    # send(self(), {:tenant_selected, Tenants.get_tenant!(id)})

    {:noreply, socket}
  end

  defp search(query) do
    Tenants.search_tenants_full_name(query)
  end
end
