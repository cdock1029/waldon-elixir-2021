defmodule WaldonWeb.TenantLive.TenantSearchComponent do
  use WaldonWeb, :live_component

  alias Waldon.Tenants

  def mount(socket) do
    {:ok, assign(socket, query: "", results: [])}
  end

  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, assign(socket, results: search(query))}
  end

  def handle_event("select", %{"tenant" => tenant}, socket) do
    message = {:tenant_selected, tenant}
    IO.puts("sending message:")
    IO.inspect(message)
    Phoenix.PubSub.broadcast!(Waldon.PubSub, "tenant:search", message)

    {:noreply, socket}
  end

  def handle_event("select", params, socket) do
    IO.puts("select no results")
    IO.inspect(params)
    {:noreply, socket}
  end

  def handle_event("submit", params, socket) do
    IO.puts("submit")
    IO.inspect(params)

    {:noreply, socket}
  end

  defp search(query) do
    Tenants.search_tenants_full_name(query)
  end
end
