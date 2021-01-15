defmodule WaldonWeb.TenantLive.Show do
  use WaldonWeb, :live_view

  alias Waldon.Tenants

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tenant, Tenants.get_tenant!(id))}
  end

  defp page_title(:show), do: "Show Tenant"
  defp page_title(:edit), do: "Edit Tenant"
end
